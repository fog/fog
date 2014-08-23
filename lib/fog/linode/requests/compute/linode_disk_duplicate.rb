module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_duplicate(linode_id, disk_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.duplicate',
              :linodeId => linode_id,
              :diskID => disk_id,
            }
          )
        end
      end

      class Mock
        def linode_disk_duplicate(linode_id, disk_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.duplicate",
            "DATA"       => { "JobID" => rand(1000..9999),
                              "DiskID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
