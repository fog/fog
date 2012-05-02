module Fog
  module Compute
    class Ecloudv2
      class Environment < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :other_links, :aliases => :Links

        def public_ips
          @public_ips ||= Fog::Compute::Ecloudv2::PublicIps.new(:connection => connection, :href => "/cloudapi/ecloud/publicIps/environments/#{id}")
        end

        def internet_services
        end

        def backup_internet_services
        end

        def networks
          @networks ||= Fog::Compute::Ecloudv2::Networks.new(:connection => connection, :href => "/cloudapi/ecloud/networks/environments/#{id}")
        end

        def servers
          @servers = []
          compute_pools.each do |c|
            c.servers.each { |s| @servers << s }
          end
          @servers
        end

        def layout
          @layout ||= Fog::Compute::Ecloudv2::Layouts.new(:connection => connection, :href => "/cloudapi/ecloud/layout/environments/#{id}").first
        end

        def tasks
          collection_based_on_type('application/vnd.tmrk.cloud.task; type=collection') 
        end

        def firewall_acls
        end

        def compute_pools
          collection_based_on_type('application/vnd.tmrk.cloud.computePool; type=collection')
        end

        def physical_devices
          @physical_devices ||= Fog::Compute::Ecloudv2::PhysicalDevices.new(:connection => connection, :href => "/cloudapi/ecloud/physicalDevices/environments/#{id}")
        end

        private

        def id
          href.scan(/\d+/)[0]
        end

        def collection_based_on_type(type, klass = nil)
          load_unless_loaded!
          if link = other_links[:Link].detect { |link| link[:type] == type }
            case type
            when "application/vnd.tmrk.cloud.deviceLayout"
    
            when "application/vnd.tmrk.cloud.physicalDevice; type=collection"
    
            when "application/vnd.tmrk.cloud.task; type=collection"
              Fog::Compute::Ecloudv2::Tasks
            when "application/vnd.tmrk.cloud.network; type=collection"
    
            when "application/vnd.tmrk.cloud.computePoolResourceSummary; type=collection"
              
            when "application/vnd.tmrk.cloud.computePool; type=collection"
              Fog::Compute::Ecloudv2::ComputePools
            end.new( :connection => connection, :href => link[:href] )
          else
            [ ]
          end
        end
      end
      Vdc = Environment
    end
  end
end
