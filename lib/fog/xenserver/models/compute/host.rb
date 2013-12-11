require 'fog/core/model'

module Fog
  module Compute
    class XenServer

      class Host < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=host

        identity :reference

        attribute :name,                                :aliases => :name_label
        attribute :uuid
        attribute :address
        attribute :allowed_operations
        attribute :api_version_major,                   :aliases => :API_version_major
        attribute :api_version_minor,                   :aliases => :API_version_minor
        attribute :api_version_vendor,                  :aliases => :API_version_vendor
        attribute :api_version_vendor_implementation,   :aliases => :API_version_vendor_implementation
        attribute :bios_strings
        attribute :blobs
        attribute :capabilities
        attribute :chipset_info
        attribute :cpu_configuration
        attribute :cpu_info
        attribute :__crash_dump_sr,                     :aliases => :crash_dump_sr
        attribute :__crashdumps,                        :aliases => :crashdumps
        attribute :current_operations
        attribute :enabled
        attribute :external_auth_configuration
        attribute :external_auth_service_name
        attribute :external_auth_type
        attribute :guest_vcpus_params,                  :aliases => :guest_VCPUs_params
        attribute :ha_network_peers
        attribute :ha_statefiles
        attribute :hostname
        attribute :license_params
        attribute :license_server
        attribute :__local_cache_sr,                    :aliases => :local_cache_sr
        attribute :logging
        attribute :memory_overhead
        attribute :__metrics,                           :aliases => :metrics
        attribute :description,                         :aliases => :name_description
        attribute :other_config
        attribute :patches
        attribute :__pbds,                              :aliases => :PBDs
        attribute :__pcis,                              :aliases => :PCIs
        attribute :__pgpus,                             :aliases => :PGPUs
        attribute :__pifs,                              :aliases => :PIFs
        attribute :power_on_config
        attribute :power_on_mode
        attribute :__resident_vms,                      :aliases => :resident_VMs
        attribute :sched_policy
        attribute :supported_bootloaders
        attribute :suspend_image_sr
        attribute :tags
        attribute :__host_cpus,                         :aliases => :host_CPUs
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
