require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class Host < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/5.6.0/1.0/en_gb/api/?c=host
        
        identity :reference
        
        attribute :name,              :aliases => :name_label
        attribute :uuid
        attribute :address
        attribute :allowed_operations
        attribute :enabled
        attribute :hostname
        attribute :__metrics,          :aliases => :metrics
        attribute :name_description
        attribute :other_config
        attribute :__pbds,            :aliases => :PBDs
        attribute :__pifs,            :aliases => :PIFs
        attribute :__resident_vms,      :aliases => :resident_VMs
        
        def pifs
          __pifs.collect { |pif| connection.pifs.get pif }
        end

        def pbds
          __pbds.collect { |pbd| connection.pbds.get pbd }
        end

        def resident_servers
          __resident_vms.collect { |ref| connection.servers.get ref }
        end

        def resident_vms
          resident_servers
        end

        def metrics
          return nil unless __metrics
          rec = connection.get_record(__metrics, 'host_metrics' )
          Fog::Compute::XenServer::HostMetrics.new(rec)
        end

      end
      
    end
  end
end
