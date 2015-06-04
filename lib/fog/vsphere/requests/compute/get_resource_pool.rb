module Fog
  module Compute
    class Vsphere
      class Real
        def get_resource_pool(name, cluster_name, datacenter_name)
          resource_pool = get_raw_resource_pool(name, cluster_name, datacenter_name)
          raise(Fog::Compute::Vsphere::NotFound) unless resource_pool
          resource_pool_attributes(resource_pool, cluster_name, datacenter_name)
        end

        protected

        def get_raw_resource_pool(name, cluster_name, datacenter_name)
          dc      = find_raw_datacenter(datacenter_name)
          cluster = dc.find_compute_resource(cluster_name)
          name.nil? ? cluster.resourcePool : cluster.resourcePool.traverse(name)
        end
      end

      class Mock
        def get_resource_pool(name, cluster_name, datacenter_name)
        end
      end
    end
  end
end
