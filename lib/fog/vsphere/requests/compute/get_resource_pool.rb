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
          dc = find_raw_datacenter(datacenter_name)
          cluster = dc.find_compute_resource(cluster_name)
          cluster.resourcePool.find name
        end

        def get_raw_resource_pool(host_system_name, datacenter_name)
          dc = find_raw_datacenter(datacenter_name)
          cluster = dc.find_compute_resource('')
          compute_resource = cluster.children.find {|c| c.name == host_system_name}
          compute_resource ? compute_resource.resourcePool : nil
        end
        
      end

      class Mock
        def get_resource_pool(name, cluster_name, datacenter_name)
        end
      end
    end
  end
end
