module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_imagize(linode_id, disk_id, description, label)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.imagize',
              :linodeId => linode_id,
              :diskId => disk_id,
              :description => description,
              :label => label
            }
          )
        end
      end

      class Mock
        def linode_disk_imagize(linode_id, disk_id, description, label)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.imagize",
            "DATA"       => {
              "JobID" => Fog::Mock.random_numbers(4),
              "ImageID" => Fog::Mock.random_numbers(4)
	    }
          }
          response
        end
      end
    end
  end
end
