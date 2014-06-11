module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_detached_disks
      end

      class Mock
        def get_detached_disks(uri)
          compute_pool_id = id_from_uri(uri)
          compute_pool    = self.data[:compute_pools][compute_pool_id]

          detached_disks  = self.data[:detached_disks].values.select{|cp| cp[:compute_pool_id] == compute_pool_id}

          detached_disks = detached_disks.map{|dd| Fog::Ecloud.slice(dd, :id, :compute_pool_id)}

          detached_disk_response = {:DetachedDisk => (detached_disks.size > 1 ? detached_disks : detached_disks.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.detachedDisk; type=collection",
            :Links => {
              :Link => Fog::Ecloud.keep(compute_pool, :name, :href, :type),
            }
          }.merge(detached_disk_response)

          response(:body => body)
        end
      end
    end
  end
end
