module Fog
  module Compute
    class Ecloudv2
      class Server < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type , :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :status, :aliases => :Status
        attribute :storage, :aliases => :Storage
        attribute :ip_addresses, :aliases => :IpAddresses
        attribute :operating_system, :aliases => :OperatingSystem
        attribute :powered_on, :aliases => :PoweredOn, :type => :boolean
        attribute :tools_status, :aliases => :ToolsStatus
        attribute :cpus, :aliases => :ProcessorCount
        attribute :memory, :aliases => :Memory
        attribute :description, :aliases => :Description
        attribute :tags, :aliases => :Tags
        attribute :layout, :aliases => :Layout

        def tasks
          @tasks ||= Fog::Compute::Ecloudv2::Tasks.new(:connection => connection, :href => "/cloudapi/ecloud/tasks/virtualMachines/#{id}")
        end

        def processes
          @processes ||= Fog::Compute::Ecloudv2::GuestProcesses.new(:connection, connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/guest/processes")
        end

        def hardware_configuration
          @hardware_configuration ||= Fog::Compute::Ecloudv2::HardwareConfigurations.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/hardwareConfiguration")[0]
        end

        def configuration
          @configuration ||= Fog::Compute::Ecloudv2::ServerConfigurationOptions.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/configurationOptions")[0]
        end

        def ips
          network_hash = ip_addresses[:AssignedIpAddresses][:Networks]
          network_hash[:Network] = network_hash[:Network].is_a?(Hash) ? [network_hash[:Network]] : network_hash[:Network]
          network_hash[:Network].each do |network|
            network[:IpAddresses][:IpAddress] = network[:IpAddresses][:IpAddress].is_a?(String) ? [network[:IpAddresses][:IpAddress]] : network[:IpAddresses][:IpAddress]
          end
          @ips = nil
          networks = Fog::Compute::Ecloudv2::Networks.new(:connection => connection, :href => "/cloudapi/ecloud/virtualMachines/#{id}/assignedIps")
          networks.each do |network|
            if networks.index(network) == 0
              @ips = network.ips.select do |ip|
                network_hash[:Network].any? do |network|
                  network[:IpAddresses][:IpAddress].include?(ip.name)
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
          task = Fog::Compute::Ecloudv2::Tasks.new(:connection => connection, :href => data[:href])[0]
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
                ip = Fog::Compute::Ecloudv2::IpAddresses.new(:connection => connection, :href => uri).detect { |i| i.host == nil }.name
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
          rnats = Fog::Compute::Ecloudv2::Rnats.new(:connection => connection, :href => "/cloudapi/ecloud/rnats/environments/#{environment_id}")
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
            task = Fog::Compute::Ecloudv2::Tasks.new(:connection => connection, :href => data[:href])[0]
          end
        end

        def create_rnat(options)
          options[:host_ip_href] ||= ips.first.href
          options[:uri] = "/cloudapi/ecloud/rnats/environments/#{environment_id}/action/createAssociation"
          data = connection.rnat_associations_create_device(options).body
          rnat = Fog::Compute::Ecloudv2::Associations.new(:connection => connection, :href => data[:href])[0]
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

        def power_operation(op)
          requires :href
          begin
            connection.send(op.keys.first, href + "/action/#{op.values.first}" )
          rescue Excon::Errors::InternalServerError => e
            #Frankly we shouldn't get here ...
            raise e unless e.to_s =~ /because it is already powered o(n|ff)/
          end
          true
        end

      end
    end
  end
end
