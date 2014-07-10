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
          if cluster_name == nil then
            cluster = dc.find_compute_resource('')
            compute_resource = cluster.children.find {|c| c.name == host_system_name}
            compute_resource ? compute_resource.resourcePool : nil
          else
            cluster = dc.find_compute_resource(cluster_name)
            cluster.resourcePool.find name
          end
        end

        def get_raw_resource_pool2(host_system_name, datacenter_name)
          ret = nil
          dc = find_raw_datacenter(datacenter_name)
          clusters = dc.find_compute_resource('')
          clusters.children.each do |cluster|
            if cluster.class.to_s=="ClusterComputeResource" then
              if cluster.host.select{|x| x.name==host_system_name}.length > 0
                ret = cluster.resourcePool
                break
              end
            else
              if c.name == host_system_name then
                ret = cluster.resourcePool
                break
              end
            end
          end
          ret
        end

        def get_raw_resource_pool3(host_system_name,datacenter_name,resource_pool,cluster_name)
          cluster = dc.find_compute_resource(cluster_name)
          cluster.resourcePool.find resource_pool
        end
        
      end

      class Mock
        def get_resource_pool(name, cluster_name, datacenter_name)
        end
      end
    end
  end
end
