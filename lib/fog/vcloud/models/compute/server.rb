require 'fog/vcloud/models/compute/helpers/status'
module Fog
  module Vcloud
    class Compute
      class Server < Fog::Vcloud::Model
        include Fog::Vcloud::Compute::Helpers::Status

        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :type
        attribute :name
        attribute :status
        attribute :deployed, :type => :boolean
        attribute :description, :aliases => :Description

        attribute :vapp_scoped_local_id, :aliases => :VAppScopedLocalId

        attribute :network_connections, :aliases => :NetworkConnectionSection#, :squash => :NetworkConnection
        attribute :virtual_hardware, :aliases => :'ovf:VirtualHardwareSection', :squash => :'ovf:Item'

        attribute :guest_customization, :aliases => :GuestCustomizationSection
        attribute :operating_system, :aliases => :'ovf:OperatingSystemSection'

        attribute :tasks, :aliases => :Tasks, :type => :array

        has_up :vapp

        def tags
          Fog::Vcloud::Compute::Tags.new(:service => service, :href => href + '/metadata')
        end

        def customization_script
          load_unless_loaded!
          self.guest_customization[:CustomizationScript]
        end

        def customization_script=(custom_script)
          @changed = true
          @update_custom_script = custom_script
        end

        def computer_name
          load_unless_loaded!
          self.guest_customization[:ComputerName]
        end

        def os_desc
          load_unless_loaded!
          self.operating_system[:'ovf:Description']
        end

        def os_type
          load_unless_loaded!
          self.operating_system[:vmw_osType]
        end

        def ip_addresses
          load_unless_loaded!
          [self.network_connections].flatten.map{|n| n[:IpAddress] }
        end

        def ready?
          reload_status # always ensure we have the correct status
          running_tasks = self.tasks && self.tasks.flatten.any? {|ti| ti.kind_of?(Hash) && ti[:status] == 'running' }
          status != '0' && !running_tasks # 0 is provisioning, and no running tasks
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
          service.undeploy href
        end

        def graceful_restart
          requires :href
          shutdown
          wait_for { off? }
          power_on
        end

        def name=(new_name)
          attributes[:name] = new_name
          @changed = true
        end

        def password
          guest_customization[:AdminPassword]
        end

        def password=(password)
          return if password.nil? or password.size == 0
          @changed = true
          @update_password = password
        end

        def cpus
          if cpu_mess
            { :count => cpu_mess[:"rasd:VirtualQuantity"].to_i,
              :units => cpu_mess[:"rasd:AllocationUnits"] }
          end
        end

        def cpus=(qty)
          return if qty.nil? or qty.size == 0

          @changed = true
          @update_cpu_value = qty
          qty
        end

        def memory
          if memory_mess
            { :amount => memory_mess[:"rasd:VirtualQuantity"].to_i,
              :units => memory_mess[:"rasd:AllocationUnits"] }
          end
        end

        def memory=(amount)
          return if amount.nil? or amount.size == 0
          @changed = true
          @update_memory_value = amount
          amount
        end

        def network
          network_connections[:NetworkConnection] if network_connections
        end

        def network=(network_info)
          @changed = true
          @update_network = network_info
          network_info
        end

        def disks
          disk_mess.map do |dm|
            { :number => dm[:"rasd:AddressOnParent"].to_i, :size => dm[:"rasd:HostResource"][:vcloud_capacity].to_i, :resource => dm[:"rasd:HostResource"], :disk_data => dm }
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
          unless persisted?
            #Lame ...
            raise RuntimeError, "Should not be here"
          else
            if on?
              if @changed
                raise RuntimeError, "Can't save cpu, name or memory changes while the VM is on."
              end
            end

            if @update_custom_script
              guest_customization[:CustomizationScript] = @update_custom_script.to_s
              service.configure_vm_customization_script(guest_customization)
              wait_for { ready? }
            end

            if @update_password
                guest_customization[:AdminPassword] = @update_password.to_s
                service.configure_vm_password(guest_customization)
                wait_for { ready? }
            end

            if @update_cpu_value
              cpu_mess[:"rasd:VirtualQuantity"] = @update_cpu_value.to_s
              service.configure_vm_cpus(cpu_mess)
              wait_for { ready? }
            end

            if @update_memory_value
              memory_mess[:"rasd:VirtualQuantity"] = @update_memory_value.to_s
              service.configure_vm_memory(memory_mess)
              wait_for { ready? }
            end

            if @update_network
              network_connections[:NetworkConnection][:network] = @update_network[:network_name]
              network_connections[:NetworkConnection][:IpAddressAllocationMode] = @update_network[:network_mode]
              service.configure_vm_network(network_connections)
              wait_for { ready? }
            end
            if @disk_change == :deleted
              data = disk_mess.delete_if do |vh|
                vh[:'rasd:ResourceType'] == '17' &&
                  vh[:'rasd:AddressOnParent'].to_s == @remove_disk.to_s
              end
              service.configure_vm_disks(self.href, data)
              wait_for { ready? }
            end
            if @disk_change == :added
              data = disk_mess
              data << @add_disk
              service.configure_vm_disks(self.href, data)
              wait_for { ready? }
            end
            if @name_changed || @description_changed
              edit_uri = links.select {|i| i[:rel] == 'edit'}
              edit_uri = edit_uri.kind_of?(Array) ? edit_uri.flatten[0][:href] : edit_uri[:href]
              service.configure_vm_name_description(edit_uri, self.name, self.description)
              wait_for { ready? }
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
          service.delete_vapp(href).body[:status] == "running"
        end
        alias_method :delete, :destroy

        private

        def reset_tracking
          @disk_change = false
          @changed = false
          @update_password = nil
          @update_cpu_value = nil
          @update_memory_value = nil
          @update_network = nil
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

        def memory_mess
          load_unless_loaded!
          if virtual_hardware
            virtual_hardware.find { |item| item[:"rasd:ResourceType"] == "4" }
          end
        end

        def cpu_mess
          load_unless_loaded!
          if virtual_hardware
            virtual_hardware.find { |item| item[:"rasd:ResourceType"] == "3" }
          end
        end

        def disk_mess
          load_unless_loaded!
          if virtual_hardware
            virtual_hardware.select { |item| item[:"rasd:ResourceType"] == "17" }
          else
            []
          end
        end

        def power_operation(op)
          requires :href
          begin
            service.send(op.keys.first, href + "/power/action/#{op.values.first}" )
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered o(n|ff)/
          end
          true
        end

        def reload_status
          server = service.get_server(href)
          self.status = server.status
          self.tasks = server.tasks
        end
      end
    end
  end
end
