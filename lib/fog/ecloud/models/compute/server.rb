module Fog
  module Compute
    class Ecloud
      class Server < Fog::Ecloud::Model
        extend Forwardable

        identity :href

        attribute :description,            :aliases => :Description
        attribute :hardware_configuration, :aliases => :HardwareConfiguration
        attribute :ip_addresses,           :aliases => :IpAddresses, :squash => :AssignedIpAddresses
        attribute :layout,                 :aliases => :Layout
        attribute :name,                   :aliases => :Name
        attribute :operating_system,       :aliases => :OperatingSystem
        attribute :other_links,            :aliases => :Links, :squash => :Link
        attribute :powered_on,             :aliases => :PoweredOn, :type => :boolean
        attribute :status,                 :aliases => :Status
        attribute :tags,                   :aliases => :Tags
        attribute :tools_status,           :aliases => :ToolsStatus
        attribute :type,                   :aliases => :Type

        def cpus
          hardware_configuration.processor_count
        end

        def memory # always in MB
          hardware_configuration.memory.to_i
        end

        def location
        end

        def flavor_id
          {:ram => hardware_configuration.memory.to_i, :cpus => hardware_configuration.processor_count}
        end

        def storage
          hardware_configuration.storage[:Disk]
        end

        def tasks
          @tasks ||= self.service.tasks(:href => "/cloudapi/ecloud/tasks/virtualMachines/#{id}")
        end

        def processes
          @processes ||= Fog::Compute::Ecloud::GuestProcesses.new(:service, service, :href => "/cloudapi/ecloud/virtualMachines/#{id}/guest/processes")
        end

        def hardware_configuration=(hardware_configuration)
          @hardware_configuration = self.service.hardware_configurations.new(hardware_configuration)
        end

        def hardware_configuration
          @hardware_configuration ||= self.service.hardware_configurations.new(:href => "/cloudapi/ecloud/virtualMachines/#{id}/hardwareConfiguration")
          @hardware_configuration.reload
        end

        def configuration
          @configuration ||= Fog::Compute::Ecloud::ServerConfigurationOptions.new(:service => service, :href => "/cloudapi/ecloud/virtualMachines/#{id}/configurationOptions")[0]
        end

        def ips
          @ips = self.service.virtual_machine_assigned_ips(:virtual_machine_id => self.id)
        end

        def networks
          @networks ||= self.service.networks(:href => "/cloudapi/ecloud/virtualMachines/#{id}/assignedIps")
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
          power_operation( :power_reset => :reboot )
        end

        def delete
          data = service.virtual_machine_delete(href).body
          self.service.tasks.new(data)
        end

        def copy(options = {})
          options = {:type => :copy}.merge(options)
          options[:source] ||= href
          if options[:type] == :copy
            options[:cpus] ||= 1
            options[:memory] ||= 512
            options[:customization] ||= :linux
            options[:tags] ||= []
            options[:powered_on] ||= false
            if options[:ips]
              options[:ips] = options[:ips].is_a?(String) ? [options[:ips]] : options[:ips]
            else
              options[:network_uri] = options[:network_uri].is_a?(String) ? [options[:network_uri]] : options[:network_uri]
              options[:network_uri].each do |uri|
                index = options[:network_uri].index(uri)
                ip = Fog::Compute::Ecloud::IpAddresses.new(:service => service, :href => uri).detect { |i| i.host == nil }.name
                options[:ips] ||= []
                options[:ips][index] = ip
              end
            end
            data = service.virtual_machine_copy("/cloudapi/ecloud/virtualMachines/computePools/#{compute_pool_id}/action/copyVirtualMachine", options).body
          elsif options[:type] == :identical
            data = service.virtual_machine_copy_identical("/cloudapi/ecloud/virtualMachines/computePools/#{compute_pool_id}/action/copyIdenticalVirtualMachine", options).body
          end
          vm = collection.from_data(data)
          vm
        end

        def rnats
          rnats = Fog::Compute::Ecloud::Rnats.new(:service => service, :href => "/cloudapi/ecloud/rnats/environments/#{environment_id}")
          associations = nil
          rnats.each do |rnat|
            if rnats.index(rnat) == 0
              associations = rnat.associations.select do |association|
                ips.any? do |ip|
                  association.name == ip.name
                end
              end
            else
              rnat.associations.select do |association|
                ips.each do |ip|
                  if ip.name == association.name
                    associations << association
                  end
                end
              end
            end
          end
          associations
        end

        def edit(options = {})
          data = service.virtual_machine_edit(href, options).body
          if data[:type] == "application/vnd.tmrk.cloud.task"
            task = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => data[:href])[0]
          end
        end

        def create_rnat(options)
          options[:host_ip_href] ||= ips.first.href
          options[:uri] = "/cloudapi/ecloud/rnats/environments/#{environment_id}/action/createAssociation"
          data = service.rnat_associations_create_device(options).body
          rnat = Fog::Compute::Ecloud::Associations.new(:service => service, :href => data[:href])[0]
        end

        def disks
          c = hardware_configuration.reload.storage
          c = c.is_a?(Hash) ? [c] : c
          @disks = c
        end

        def add_disk(size)
          index = disks.map { |d| d[:Index].to_i }.sort[-1] + 1
          vm_disks = disks << {:Index => index.to_s, :Size=>{:Unit => "GB", :Value => size.to_s}, :Name => "Hard Disk #{index + 1}"}
          data = service.virtual_machine_edit_hardware_configuration(href + "/hardwareConfiguration", _configuration_data(:disks => vm_disks)).body
          task = self.service.tasks.new(data)
        end

        def detach_disk(index)
          options               = {}
          options[:disk]        = disks.detect { |disk_hash| disk_hash[:Index] == index.to_s }
          options[:name]        = self.name
          options[:description] = self.description
          data                  = service.virtual_machine_detach_disk(href + "/hardwareconfiguration/disks/actions/detach", options).body
          detached_disk         = self.service.detached_disks.new(data)
        end

        def attach_disk(detached_disk)
          options        = {}
          options[:name] = detached_disk.name
          options[:href] = detached_disk.href
          data           = service.virtual_machine_attach_disk(href + "/hardwareconfiguration/disks/actions/attach", options).body
          task           = self.service.tasks.new(data)
        end

        def delete_disk(index)
          vm_disks = disks.delete_if { |h| h[:Index] == index.to_s }
          data     = service.virtual_machine_edit_hardware_configuration(href + "/hardwareconfiguration", _configuration_data(:disks => vm_disks)).body
          task     = self.service.tasks.new(data)
        end

        def nics
          c = hardware_configuration.network_cards
          c = c.is_a?(Hash) ? [c] : c
          @nics = c
        end

        def add_nic(network)
          unit_number = nics.map { |n| n[:UnitNumber].to_i }.sort[-1] + 1
          vm_nics = nics << {:UnitNumber => unit_number, :Network => {:href => network.href, :name => network.name, :type => "application/vnd.tmrk.cloud.network"}}
          data = service.virtual_machine_edit_hardware_configuration(href + "/hardwareConfiguration", _configuration_data(:nics => vm_nics)).body
          task = self.service.tasks.new(:href => data[:href])[0]
        end

        def add_ip(options)
          slice_ips = begin
                        ips
                      rescue
                        []
                      end
          slice_networks = if slice_ips.empty?
                             []
                           else
                             ips.map { |ip| {:href => ip.network.href, :name => ip.network.name.split(' ')[0], :type => ip.network.type} }.push({:href => options[:href], :name => options[:network_name], :type => "application/vnd.tmrk.cloud.network"}).uniq
                           end
          slice_ips = slice_ips.map { |i| {:name => i.address.name, :network_name => i.network.name} }.push({:name => options[:ip], :network_name => options[:network_name]}).uniq
          slice_ips.each do |ip|
            slice_networks.each do |network|
              if network[:name] == ip[:network_name]
                network[:ips] ||= []
                network[:ips].push(ip[:name])
              end
            end
          end
          data = service.virtual_machine_edit_assigned_ips(href + "/assignedIps", slice_networks).body
          task = self.service.tasks.new(data)
        end

        def delete_ip(options)
          slice_ips = begin
                        ips
                      rescue
                        []
                      end
          slice_networks = if slice_ips.empty?
                             []
                           else
                             ips.map do |ip|
                               {
                                 :href => ip.network.href,
                                 :name => ip.network.name.split(' ')[0],
                                 :type => ip.network.type,
                               }
                             end#.delete_if { |ip| ip[:href] == options[:href] && ip[:name] == options[:network_name] }
                           end
          slice_ips.map! { |i| {:name => i.address.name, :network_name => i.network.name, :network_name => i.network.name } }.delete_if { |ip| ip[:name] == options[:ip] }
          slice_ips.each do |ip|
            slice_networks.each do |network|
              if network[:name] == ip[:network_name]
                network[:ips].delete(ip[:name])
              end
            end
          end
          data = service.virtual_machine_edit_assigned_ips(href + "/assignedips", slice_networks).body
          task = self.service.tasks.new(data)
        end

        def upload_file(options)
          service.virtual_machine_upload_file(href + "/guest/action/files", options)
          true
        end

        def storage_size
          vm_disks = disks
          disks.map! { |d| d[:Size][:Value].to_i }.inject(0){|sum,item| sum + item} * 1024 * 1024
        end

        def ready?
          load_unless_loaded!
          unless status =~ /NotDeployed|Orphaned|TaskInProgress|CopyInProgress/
            true
          else
            false
          end
        end

        def on?
          powered_on == true
        end

        def off?
          powered_on == false
        end

        def compute_pool_id
          other_links.detect { |l| l[:type] == "application/vnd.tmrk.cloud.computePool" }[:href].scan(/\d+/)[0]
        end

        def compute_pool
          reload if other_links.nil?
          @compute_pool = self.service.compute_pools.new(:href => other_links.detect { |l| l[:type] == "application/vnd.tmrk.cloud.computePool" }[:href])
        end

        def environment_id
          other_links.detect { |l| l[:type] == "application/vnd.tmrk.cloud.environment" }[:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end

        private

        def _configuration_data(options = {})
          {:cpus => (options[:cpus] || hardware_configuration.processor_count), :memory => (options[:memory] || hardware_configuration.memory), :disks => (options[:disks] || disks), :nics => (options[:nics] || nics)}
        end

        def power_operation(op)
          requires :href
          begin
            service.send(op.keys.first, href + "/action/#{op.values.first}" )
          rescue Excon::Errors::Conflict => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered o(n|ff)/
          end
          true
        end

        alias destroy delete
      end
    end
  end
end
