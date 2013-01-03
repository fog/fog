module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_detached_disk
      end

      class Mock
        def get_detached_disk(uri)
          detached_disk_id = id_from_uri(uri)
          detached_disk    = self.data[:detached_disks][detached_disk_id]

          if detached_disk
            response(:body => Fog::Ecloud.slice(detached_disk, :id, :compute_pool_id))
          else response(status: 404) # ?
          end
        end
      end
    end
  end
end
