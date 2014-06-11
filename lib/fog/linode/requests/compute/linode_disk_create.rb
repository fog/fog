module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_create(linode_id, name, type, size)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.create',
              :linodeId => linode_id,
              :label => name,
              :type => type,
              :size => size
            }
          )
        end
      end

      class Mock
        def linode_disk_create(linode_id, name, type, size)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.create",
            "DATA"       => { "JobID" => rand(1000..9999),
                              "DiskID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
