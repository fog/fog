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
          folder ||= find_raw_datacenter(datacenter).hostFolder
          @raw_clusters = get_raw_clusters_from_folder(folder)
        end

        protected

        def get_raw_clusters_from_folder(folder)
          folder.childEntity.map do |child_entity|
            if child_entity.is_a? RbVmomi::VIM::ComputeResource
              child_entity
            elsif child_entity.is_a? RbVmomi::VIM::Folder
              get_raw_clusters_from_folder(child_entity)
            end
          end.flatten
        end

        def cluster_attributes cluster, datacenter_name
          {
            :id             => managed_obj_id(cluster),
            :name           => cluster.name,
            :full_path      => cluster_path(cluster, datacenter_name),
            :num_host       => cluster.summary.numHosts,
            :num_cpu_cores  => cluster.summary.numCpuCores,
            :overall_status => cluster.summary.overallStatus,
            :datacenter     => datacenter_name || parent_attribute(cluster.path, :datacenter)[1],
          }
        end

        def cluster_path(cluster, datacenter_name)
          datacenter = find_raw_datacenter(datacenter_name)
          cluster.pretty_path.gsub(/(#{datacenter_name}|#{datacenter.hostFolder.name})\//,'')
        end
      end

      class Mock
        def list_clusters(filters = { })
          raw_clusters.map do |cluster|
            cluster
          end
        end

        def raw_clusters
          folder = self.data[:clusters]
          @raw_clusters = get_raw_clusters_from_folder(folder)
        end

        def get_raw_clusters_from_folder(folder)
          folder.map do |child|
            if child[:klass] == "RbVmomi::VIM::ComputeResource"
               child
            elsif child[:klass] == "RbVmomi::VIM::Folder"
              get_raw_clusters_from_folder(child[:clusters])
            end
          end.flatten
        end
      end
    end
  end
end
