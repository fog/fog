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
        attribute :__host_cpus,         :aliases => :host_CPUs
        attribute :edition
        attribute :software_version
        
        def pifs
          __pifs.collect { |pif| service.pifs.get pif }
        end

        def pbds
          __pbds.collect { |pbd| service.pbds.get pbd }
        end

        def resident_servers
          __resident_vms.collect { |ref| service.servers.get ref }
        end

        def resident_vms
          resident_servers
        end

        def host_cpus
          cpus = []
          (__host_cpus || []).each do |ref|
            cpu_ref = service.get_record(ref, 'host_cpu' )
            cpu_ref[:service] = service
            cpus << Fog::Compute::XenServer::HostCpu.new(cpu_ref)
          end
          cpus
        end

        def metrics
          return nil unless __metrics
          rec = service.get_record(__metrics, 'host_metrics' )
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
          service.reboot_host(reference)
        end
        
        #
        # Puts the host into a state in which no new VMs can be started. 
        # Currently active VMs on the host continue to execute.
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def disable 
          service.disable_host(reference)
        end
        
        #
        # Puts the host into a state in which new VMs can be started. 
        #
        # @see http://docs.vmd.citrix.com/XenServer/6.0.0/1.0/en_gb/api/?c=host
        #
        def enable
          service.enable_host(reference)
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
          service.shutdown_host(reference)
        end
        
        def set_attribute(name, *val)
          data = service.set_attribute( 'host', reference, name, *val )
          # Do not reload automatically for performance reasons
          # We can set multiple attributes at the same time and
          # then reload manually
          #reload
        end

      end

    end
  end
end
