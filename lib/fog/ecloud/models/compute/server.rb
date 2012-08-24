module Fog
  module Compute
    class Ecloud
      class Server < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type , :aliases => :Type
        attribute :other_links, :aliases => :Link
        attribute :status, :aliases => :Status
        attribute :storage, :aliases => :Storage
        attribute :ip_addresses, :aliases => :IpAddresses
        attribute :operating_system, :aliases => :OperatingSystem
        attribute :powered_on, :aliases => :PoweredOn, :type => :boolean
        attribute :tools_status, :aliases => :ToolsStatus
        attribute :cpus, :aliases => :ProcessorCount, :type => :integer
        attribute :memory, :aliases => :Memory
        attribute :description, :aliases => :Description
        attribute :tags, :aliases => :Tags
        attribute :layout, :aliases => :Layout

        def tasks
          @tasks ||= Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => "/cloudapi/ecloud/tasks/virtualMachines/#{id}")
        end

        def processes
          @processes ||= Fog::Compute::Ecloud::GuestProcesses.new(:connection, connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/guest/processes")
        end

        def hardware_configuration
          @hardware_configuration ||= Fog::Compute::Ecloud::HardwareConfigurations.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/hardwareConfiguration")[0]
        end

        def configuration
          @configuration ||= Fog::Compute::Ecloud::ServerConfigurationOptions.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/configurationOptions")[0]
        end


        def ips
          network_hash = ip_addresses[:AssignedIpAddresses][:Networks] || []
          network_hash[:Network] = network_hash[:Network].is_a?(Hash) ? [network_hash[:Network]] : network_hash[:Network]
          network_hash[:Network].each do |network|
            network[:IpAddresses][:IpAddress] = network[:IpAddresses][:IpAddress].is_a?(String) ? [network[:IpAddresses][:IpAddress]] : network[:IpAddresses][:IpAddress]
          end
          @ips = nil
          networks = Fog::Compute::Ecloud::Networks.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/assignedIps")
          networks.each do |network|
            if networks.index(network) == 0
              if @ips.nil?
                @ips = network.ips.select do |ip|
                  network_hash[:Network].any? do |network|
                    network[:IpAddresses][:IpAddress].include?(ip.name)
                  end
                end
              else
                network.ips.each do |ip|
                  network_hash[:Network].any? do |network|
                    network[:IpAddresses][:IpAddress].each do |i|
                      @ips << ip if i == ip.name
                    end
                  end
                end
              end
            else
              network.ips.each do |ip|
                network_hash[:Network].each do |network|
                  network[:IpAddresses][:IpAddress].each do |i|
                    @ips << ip if i == ip.name
                  end
                end
              end
            end
          end
          @ips
        end

        def networks
          @networks ||= Fog::Compute::Ecloud::Networks.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/assignedIps")
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
          data = connection.virtual_machine_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
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
                ip = Fog::Compute::Ecloud::IpAddresses.new(:connection => connection, :href => uri).detect { |i| i.host == nil }.name
                options[:ips] ||= []
                options[:ips][index] = ip
              end
            end
            data = connection.virtual_machine_copy("/cloudapi/ecloud/virtualMachines/computePools/#{compute_pool_id}/action/copyVirtualMachine", options).body
          elsif options[:type] == :identical
            data = connection.virtual_machine_copy_identical("/cloudapi/ecloud/virtualMachines/computePools/#{compute_pool_id}/action/copyIdenticalVirtualMachine", options).body
          end
          vm = collection.from_data(data)
          vm
        end

        def rnats
          rnats = Fog::Compute::Ecloud::Rnats.new(:connection => connection, :href => "/cloudapi/ecloud/rnats/environments/#{environment_id}")
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
          data = connection.virtual_machine_edit(href, options).body
          if data[:type] == "application/vnd.tmrk.cloud.task"
            task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
          end
        end

        def create_rnat(options)
          options[:host_ip_href] ||= ips.first.href
          options[:uri] = "/cloudapi/ecloud/rnats/environments/#{environment_id}/action/createAssociation"
          data = connection.rnat_associations_create_device(options).body
          rnat = Fog::Compute::Ecloud::Associations.new(:connection => connection, :href => data[:href])[0]
        end
        
        def disks
          c = hardware_configuration.reload.storage[:Disk]
          c = c.is_a?(Hash) ? [c] : c
          @disks = c
        end

        def add_disk(size)
          index = disks.map { |d| d[:Index].to_i }.sort[-1] + 1
          vm_disks = disks << {:Index => index, :Size=>{:Unit => "GB", :Value => size}}
          data = connection.virtual_machine_edit_hardware_configuration(href + "/hardwareConfiguration", _configuration_data(:disks => vm_disks)).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def nics
          c = hardware_configuration.network_cards[:Nic]
          c = c.is_a?(Hash) ? [c] : c
          @nics = c
        end

        def add_nic(network)
          unit_number = nics.map { |n| n[:UnitNumber].to_i }.sort[-1] + 1
          vm_nics = nics << {:UnitNumber => unit_number, :Network => {:href => network.href, :name => network.name, :type => "application/vnd.tmrk.cloud.network"}}
          data = connection.virtual_machine_edit_hardware_configuration(href + "/hardwareConfiguration", _configuration_data(:nics => vm_nics)).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def add_ip(options)
          begin
            slice_ips = ips
          rescue
            slice_ips = []
          end
          begin
            slice_networks = networks
          rescue
            slice_networks = []
          end
          slice_networks = slice_networks.map { |n| {:href => n.href, :name => n.name.split(' ')[0], :type => 'application/vnd.tmrk.cloud.network'} }.push({:href => options[:href], :name => options[:network_name], :type => 'application/vnd.tmrk.cloud.network'}).uniq
          slice_ips = slice_ips.map { |i| {:name => i.name, :network_name => i.other_links[:Link][:name]} }.push({:name => options[:ip], :network_name => options[:network_name]})
          slice_ips.each do |ip|
            slice_networks.each do |network|
              if network[:name] == ip[:network_name]
                network[:ips] ||= []
                network[:ips].push(ip[:name])
              end
            end
          end
          data = connection.virtual_machine_add_ip(href + "/assignedIps", slice_networks).body
          task = Fog::Compute::Ecloud::Tasks.new(:connection => connection, :href => data[:href])[0]
        end

        def upload_file(options)
          connection.virtual_machine_upload_file(href + "/guest/action/files", options)
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
          other_links[:Link].detect { |l| l[:type] == "application/vnd.tmrk.cloud.computePool" }[:href].scan(/\d+/)[0]
        end

        def environment_id
          other_links[:Link].detect { |l| l[:type] == "application/vnd.tmrk.cloud.environment" }[:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end

        private

        def _configuration_data(options = {})
          {:cpus => (options[:cpus] || hardware_configuration.processor_count), :memory => (options[:memory] || hardware_configuration.mem), :disks => (options[:disks] || disks), :nics => (options[:nics] || nics)}
        end

        def power_operation(op)
          requires :href
          begin
            connection.send(op.keys.first, href + "/action/#{op.values.first}" )
          rescue Excon::Errors::Conflict => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered o(n|ff)/
          end
          true
        end

      end
    end
  end
end
