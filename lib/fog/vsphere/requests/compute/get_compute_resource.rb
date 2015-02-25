module Fog
  module Compute
    class Vsphere
      class Real
        def get_compute_resource(name, datacenter_name)
          compute_resource = get_raw_compute_resource(name, datacenter_name)
          raise(Fog::Compute::Vsphere::NotFound) unless compute_resource
          compute_resource_attributes(compute_resource, datacenter_name)
        end

        protected

        def get_raw_compute_resource(name, datacenter_name)
          find_raw_datacenter(datacenter_name).find_compute_resource(name)
        end
      end

      class Mock
        def get_compute_resource(name, datacenter_name)
          {
            :id=>"domain-s7", 
            :name=>"fake-host", 
            :totalCpu=>33504, 
            :totalMemory=>154604142592, 
            :numCpuCores=>12, 
            :numCpuThreads=>24, 
            :effectiveCpu=>32247, 
            :effectiveMemory=>135733, 
            :numHosts=>1, 
            :numEffectiveHosts=>1, 
            :overallStatus=>"gray", 
            :overallCpuUsage=>15682, 
            :overallMemoryUsage=>132755, 
            :effective=>true, 
            :isSingleHost=>true
          }
        end
      end
    end
  end
end
