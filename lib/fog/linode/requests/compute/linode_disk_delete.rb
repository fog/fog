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

      class Mock
        def linode_disk_delete(linode_id, disk_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.delete",
            "DATA"       => { "JobID" => rand(1000..9999),
                              "DiskID" => disk_id }
          }
          response
        end
      end
    end
  end
end
