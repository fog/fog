module Fog
  module Compute
    class Linode
      class Real

        def linode_disk_delete(linode_id, disk_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.delete',
              :linodeId => linode_id,
              :diskId => disk_id
            }
          )
        end

      end
    end
  end
end
