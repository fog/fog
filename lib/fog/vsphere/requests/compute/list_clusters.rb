module Fog
  module Compute
    class Vsphere
      class Real
        def list_clusters(filters = { })
          datacenter_name = filters[:datacenter]

          raw_clusters(datacenter_name).map do |cluster|
            cluster_attributes(cluster, datacenter_name)
          end
        end

        def raw_clusters(datacenter)
          find_raw_datacenter(datacenter).hostFolder.childEntity.grep(RbVmomi::VIM::ClusterComputeResource)
        end

        protected

        def cluster_attributes cluster, datacenter_name
          {
            :id             => managed_obj_id(cluster),
            :name           => cluster.name,
            :num_host       => cluster.summary.numHosts,
            :num_cpu_cores  => cluster.summary.numCpuCores,
            :overall_status => cluster.summary.overallStatus,
            :datacenter     => datacenter_name || parent_attribute(cluster.path, :datacenter)[1],
          }
        end

      end
      class Mock
        def list_clusters(filters = { })
        end
      end
    end
  end
end
