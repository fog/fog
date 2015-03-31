module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_resize(linode_id, disk_id, size)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.resize',
              :linodeId => linode_id,
              :diskId => disk_id,
              :size => size
            }
          )
        end
      end

      class Mock
        def linode_disk_resize(linode_id, disk_id, size)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.resize",
            "DATA"       => {
              "JobID" => Fog::Mock.random_numbers(4),
              "DiskID" => Fog::Mock.random_numbers(4)
	    }
          }
          response
        end
      end
    end
  end
end
