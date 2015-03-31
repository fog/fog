module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_update(linode_id, disk_id, label, isreadonly)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.update',
              :linodeId => linode_id,
              :diskId => disk_id,
              :label => label,
              :isReadOnly => isreadonly
            }
          )
        end
      end

      class Mock
        def linode_disk_update(linode_id, disk_id, label, isreadonly)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.update",
            "DATA"       => { "DiskID" => Fog::Mock.random_numbers(5) }
          }
          response
        end
      end
    end
  end
end
