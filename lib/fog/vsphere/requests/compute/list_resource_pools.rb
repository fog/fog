module Fog
  module Compute
    class Vsphere
      class Real
        def list_resource_pools(filters = { })
          datacenter_name = filters[:datacenter]
          cluster_name    = filters[:cluster]
          cluster         = get_raw_cluster(cluster_name, datacenter_name)
          list_raw_resource_pools(cluster).map do |resource_pool|
            resource_pool_attributes(resource_pool, cluster_name, datacenter_name)
          end
        end

        protected

        # root ResourcePool + Children if they exists
        def list_raw_resource_pools(cluster)
          [cluster.resourcePool, cluster.resourcePool.resourcePool].flatten
        end

        def resource_pool_attributes resource_pool, cluster, datacenter
          {
            :id                   => managed_obj_id(resource_pool),
            :name                 => resource_pool.name,
            :configured_memory_mb => resource_pool.summary.configuredMemoryMB,
            :overall_status       => resource_pool.overallStatus,
            :cluster              => cluster,
            :datacenter           => datacenter
          }
        end
      end
      class Mock
        def list_resource_pools(filters = { })
        end
      end
    end
  end
end
