module Fog
  module Compute
    class Vsphere
      class Real
        def list_host_systems(filters = { })
          datacenter_name = filters[:datacenter]
          # default to show all compute_resources
          only_active = filters[:effective] || false
          datacenters = find_datacenters(datacenter_name)
          hosts = datacenters.map do |dc|
            @connection.serviceContent.viewManager.CreateContainerView({
              :container  => dc.hostFolder,
              :type       =>  ["HostSystem"],
              :recursive  => true
            }).view
          end.flatten
          # compute_resources = raw_compute_resources datacenter_name
          
          hosts.map do |host_system|
             next if only_active and !is_host_system_active?(host_system)
             host_system_attributes(host_system, datacenter_name)
          end.compact
        end
        
        protected
        
        def is_host_system_active? host_system
          runtime = host_system.runtime
          runtime.connectionState == 'connected' && !runtime.inMaintenanceMode && runtime.standbyMode == 'none' && runtime.powerState == 'poweredOn'
        end

        def host_system_attributes host, datacenter
          {
            :id                 =>   managed_obj_id(host),
            :name               =>   host.name,
            :totalCpu           =>   host.hardware.cpuInfo.numCpuCores*host.hardware.cpuInfo.hz/(1024*1024), #from Hz to MHz
            :totalMemory        =>   host.hardware.memorySize/(1024*1024), #from Byte to MB
            :overallCpuUsage    =>   host.summary.quickStats.overallCpuUsage, #in MHz
            :overallMemoryUsage =>   host.summary.quickStats.overallMemoryUsage,#in MB
            :effective          =>   is_host_system_active?(host)
          }
        end

      end
      class Mock
        def list_host_systems(filters = { })
          []
        end
      end
    end
  end
end