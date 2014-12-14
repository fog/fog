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
        def get_host_system(name, datacenter_name)
          datacenters = find_datacenters(datacenter_name)
          hosts = datacenters.map do |dc|
            @connection.serviceContent.viewManager.CreateContainerView({
              :container  => dc.hostFolder,
              :type       =>  ["HostSystem"],
              :recursive  => true
            }).view
          end.flatten
          return hosts.select{|h| h.name == name}.first
        end

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
          datacenters = find_datacenters(datacenter_name)
          hosts = datacenters.map do |dc|
            @connection.serviceContent.viewManager.CreateContainerView({
              :container  => dc.hostFolder,
              :type       =>  ["ComputeResource"],
              :recursive  => true
            }).view
          end.flatten

          ret = nil
          hosts.each do |cluster|
            if cluster.class==RbVmomi::VIM::ClusterComputeResource then
              if cluster.host.find{|h|h.name==host_system_name}
                ret = cluster.resourcePool
                break
              end
            else
              if cluster.name == host_system_name then
                ret = cluster.resourcePool
                break
              end
            end
          end
          ret
        end

        def get_raw_resource_pool3(host_system_name,datacenter_name,resource_pool,cluster_name)
          cluster = dc.find_compute_resource(cluster_name)
          raise "host_system does not exist in cluster" unless cluster.host.find{|h|h.name==host_system_name}
          ret = cluster.resourcePool.find resource_pool
          raise "host_system does not exist in cluster" unless ret
          ret
        end
        
      end

      class Mock
        def get_resource_pool(name, cluster_name, datacenter_name)
        end
      end
    end
  end
end
