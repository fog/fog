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

        #
        # Reboot the host disabling it first unless auto_disable is 
        # set to false
        # 
        # This function can only be called if there are no currently running 
        # VMs on the host and it is disabled. If there are running VMs, it will
        # raise an exception.
        #
        # @param [Boolean] auto_disable disable the host first
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def reboot(auto_disable = true)
          disable if auto_disable
          connection.reboot_host(reference)
        end
        
        #
        # Puts the host into a state in which no new VMs can be started. 
        # Currently active VMs on the host continue to execute.
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def disable 
          connection.disable_host(reference)
        end
        
        #
        # Puts the host into a state in which new VMs can be started. 
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def enable
          connection.enable_host(reference)
        end

        #
        # Shutdown the host disabling it first unless auto_disable is 
        # set to false.
        #
        # This function can only be called if there are no currently running 
        # VMs on the host and it is disabled. If there are running VMs, it will
        # raise an exception.
        #
        # @param [Boolean] auto_disable disable the host first
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def shutdown(auto_disable = true)
          disable if auto_disable
          connection.shutdown_host(reference)
        end
        
        def set_attribute(name, *val)
          data = connection.set_attribute( 'host', reference, name, *val )
          # Do not reload automatically for performance reasons
          # We can set multiple attributes at the same time and
          # then reload manually
          #reload
        end

      end
      
    end
  end
end
