module Fog
  module Vcloud
    class Compute
      class Server < Fog::Vcloud::Model

        identity :href, :aliases => :Href

        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :type
        attribute :name
        attribute :status
        attribute :network_connections, :aliases => :NetworkConnectionSection, :squash => :NetworkConnection
        attribute :os, :aliases => :OperatingSystemSection
        attribute :virtual_hardware, :aliases => :VirtualHardwareSection
        attribute :description, :aliases => :Description
        attribute :storage_size, :aliases => :size
        attribute :links, :aliases => :Link, :type => :array
        attribute :tasks, :aliases => :Tasks, :type => :array

        attribute :vm_data, :aliases => :Children, :squash => :Vm

        def ip_address
          load_unless_loaded!
          vm[0][:NetworkConnectionSection][:NetworkConnection][:IpAddress]
        end

        def friendly_status
          load_unless_loaded!
          case status
          when '0'
            'creating'
          when '8'
            'off'
          when '4'
            'on'
          else
            'unkown'
          end
        end

        def ready?
          reload_status # always ensure we have the correct status
          running_tasks = tasks && tasks.flatten.any? {|ti| ti.kind_of?(Hash) && ti[:status] == 'running' }
          status != '0' && !running_tasks # 0 is provisioning, and no running tasks
        end

        def on?
          reload_status # always ensure we have the correct status
          status == '4'
        end

        def off?
          reload_status # always ensure we have the correct status
          status == '8'
        end

        def power_on
          power_operation( :power_on => :powerOn )
        end

        def power_off
          power_operation( :power_off => :powerOff )
        end

        def shutdown
          power_operation( :power_shutdown => :shutdown )
        end

        def power_reset
          power_operation( :power_reset => :reset )
        end

        # This is the real power-off operation
        def undeploy
          connection.undeploy href
        end

        def graceful_restart
          requires :href
          shutdown
          wait_for { off? }
          power_on
        end

        def vm
          load_unless_loaded!
          self.vm_data
        end

        def name=(new_name)
          attributes[:name] = new_name
          @changed = true
        end

        def cpus
          if cpu_mess
            { :count => cpu_mess[:"rasd:VirtualQuantity"].to_i,
              :units => cpu_mess[:"rasd:AllocationUnits"] }
          end
        end

        def cpus=(qty)
          @changed = true
          cpu_mess[:"rasd:VirtualQuantity"] = qty.to_s
        end

        def memory
          if memory_mess
            { :amount => memory_mess[:"rasd:VirtualQuantity"].to_i,
              :units => memory_mess[:"rasd:AllocationUnits"] }
          end
        end

        def memory=(amount)
          @changed = true
          @update_memory_value = amount
          amount
        end

        def disks
          disk_mess.map do |dm|
            { :number => dm[:"rasd:AddressOnParent"], :size => dm[:"rasd:VirtualQuantity"].to_i, :resource => dm[:"rasd:HostResource"] }
          end
        end

        def add_disk(size)
          if @disk_change == :deleted
            raise RuntimeError, "Can't add a disk w/o saving changes or reloading"
          else
            load_unless_loaded!
            @disk_change = :added

            @add_disk = {
              :'rasd:HostResource' => {:vcloud_capacity => size},
              :'rasd:AddressOnParent' =>  (disk_mess.map { |dm| dm[:'rasd:AddressOnParent'] }.sort.last.to_i + 1).to_s,
              :'rasd:ResourceType' => '17'
            }
          end
          true
        end

        def delete_disk(number)
          if @disk_change == :added
            raise RuntimeError, "Can't delete a disk w/o saving changes or reloading"
          else
            load_unless_loaded!
            unless number == 0
              @disk_change = :deleted
              @remove_disk = number
            end
          end
          true
        end

        def description=(description)
          @description_changed = true unless attributes[:description] == description || attributes[:description] == nil
          attributes[:description] = description
        end

        def name=(name)
          @name_changed = true unless attributes[:name] == name || attributes[:name] == nil
          attributes[:name] = name
        end

        def reload
          reset_tracking
          super
        end

        def save
          if new_record?
            #Lame ...
            raise RuntimeError, "Should not be here"
          else
            if on?
              if @changed
                raise RuntimeError, "Can't save cpu, name or memory changes while the VM is on."
              end
            end
            if @update_memory_value
              memory_mess[:"rasd:VirtualQuantity"] = @update_memory_value.to_s
              connection.configure_vm_memory(memory_mess)
            end
            if @disk_change == :deleted
              data = disk_mess.delete_if do |vh|
                vh[:'rasd:ResourceType'] == '17' &&
                  vh[:'rasd:AddressOnParent'].to_s == @remove_disk.to_s
              end
              connection.configure_vm_disks(vm_href, data)
            end
            if @disk_change == :added
              data = disk_mess
              data << @add_disk
              connection.configure_vm_disks(vm_href, data)
            end
            if @name_changed || @description_changed
              edit_uri = links.select {|i| i[:rel] == 'edit'}
              edit_uri = edit_uri.kind_of?(Array) ? edit_uri.flatten[0][:href] : edit_uri[:href]
              connection.configure_vm_name_description(edit_uri, self.name, self.description)
            end
          end
          reset_tracking
          true
        end

        def destroy
          if on?
            undeploy
            wait_for { off? }
          end
          wait_for { off? } # be sure..
          wait_for { ready? } # be doubly sure..
          sleep 2 # API lies. need to give it some time to be happy.
          connection.delete_vapp(href).body[:status] == "running"
        end
        alias :delete :destroy

        def vm_href
          load_unless_loaded!
          #require 'pp'
          #pp vm_data
          #vm_data[0][:Link].select {|v| v[:rel] == 'edit'}[0][:href]
          vm_data.kind_of?(Array)? vm_data[0][:href] : vm_data[:href]
        end

        private

        def reset_tracking
          @disk_change = false
          @changed = false
          @update_memory_value = nil
          @name_changed = false
          @description_changed = nil
        end

        def _compose_vapp_data
          { :name   => name,
            :cpus   => cpus[:count],
            :memory => memory[:amount],
            :disks  => disks
          }
        end

        def virtual_hardware_section
          load_unless_loaded!
          vm[0][:"ovf:VirtualHardwareSection"][:"ovf:Item"]
        end

        def memory_mess
          load_unless_loaded!
          if virtual_hardware_section
            virtual_hardware_section.detect { |item| item[:"rasd:ResourceType"] == "4" }
          end
        end

        def cpu_mess
          load_unless_loaded!
          if virtual_hardware_section
            virtual_hardware_section.detect { |item| item[:"rasd:ResourceType"] == "3" }
          end
        end

        def disk_mess
          load_unless_loaded!
          if virtual_hardware_section
            virtual_hardware_section.select { |item| item[:"rasd:ResourceType"] == "17" }
          else
            []
          end
        end

        def power_operation(op)
          requires :href
          begin
            connection.send(op.keys.first, href + "/power/action/#{op.values.first}" )
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered o(n|ff)/
          end
          true
        end

        def reload_status
          self.status = connection.get_vapp(href).body[:status]
        end

      end
    end
  end
end
