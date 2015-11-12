module Fog
  module Compute
    class Vsphere
      class Real
        def list_compute_resources(filters = { })
          datacenter_name = filters[:datacenter]
          # default to show all compute_resources
          only_active = filters[:effective] || false
          compute_resources = raw_compute_resources datacenter_name
          
          compute_resources.map do |compute_resource|
            summary = compute_resource.summary
            next if only_active and summary.numEffectiveHosts == 0
            compute_resource_attributes(compute_resource, datacenter_name)
          end.compact
        end
        
        def raw_compute_resources(datacenter_name)
          find_raw_datacenter(datacenter_name).find_compute_resource('').children
        end

        protected

        def compute_resource_attributes compute_resource, datacenter
          overall_usage = compute_resource.host.inject({:overallCpuUsage=>0, :overallMemoryUsage=>0}) do |sum, host|
            {
              :overallCpuUsage => sum[:overallCpuUsage]+(host.summary.quickStats.overallCpuUsage || 0), 
              :overallMemoryUsage=> sum[:overallMemoryUsage]+(host.summary.quickStats.overallMemoryUsage || 0)
            }
          end
          {
            :id                 =>   managed_obj_id(compute_resource),
            :name               =>   compute_resource.name,
            :totalCpu           =>   compute_resource.summary.totalCpu, 
            :totalMemory        =>   compute_resource.summary.totalMemory,
            :numCpuCores        =>   compute_resource.summary.numCpuCores, 
            :numCpuThreads      =>   compute_resource.summary.numCpuThreads,
            :effectiveCpu       =>   compute_resource.summary.effectiveCpu,
            :effectiveMemory    =>   compute_resource.summary.effectiveMemory,
            :numHosts           =>   compute_resource.summary.numHosts,
            :numEffectiveHosts  =>   compute_resource.summary.numEffectiveHosts,
            :overallStatus      =>   compute_resource.summary.overallStatus,
            :overallCpuUsage    =>   overall_usage[:overallCpuUsage],
            :overallMemoryUsage =>   overall_usage[:overallMemoryUsage],
            :effective          =>   compute_resource.summary.numEffectiveHosts > 0,
            :isSingleHost       =>   compute_resource.summary.numHosts == 1
          }
        end

      end
      class Mock
        def list_compute_resources(filters = { })
          [
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
            }, {
              :id=>"domain-s74", 
              :name=>"fake-cluster", 
              :totalCpu=>41484, 
              :totalMemory=>51525996544, 
              :numCpuCores=>12, 
              :numCpuThreads=>24, 
              :effectiveCpu=>37796, 
              :effectiveMemory=>45115, 
              :numHosts=>2, 
              :numEffectiveHosts=>2, 
              :overallStatus=>"gray", 
              :overallCpuUsage=>584, 
              :overallMemoryUsage=>26422, 
              :effective=>true, 
              :isSingleHost=>false
            }
          ]
        end
      end
    end
  end
end