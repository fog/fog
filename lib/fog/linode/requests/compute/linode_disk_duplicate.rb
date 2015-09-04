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
            "DATA"       => { "JobID" => Fog::Mock.random_numbers(4),
                              "DiskID" => Fog::Mock.random_numbers(5) }
          }
          response
        end
      end
    end
  end
end
