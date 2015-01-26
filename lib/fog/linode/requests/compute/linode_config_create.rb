module Fog
  module Compute
    class Linode
      class Real
        def linode_config_create(linode_id, kernel_id, name, disk_list)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.config.create',
              :linodeId => linode_id,
              :kernelId => kernel_id,
              :label => name,
              :diskList => disk_list
            }
          )
        end
      end

      class Mock
        def linode_config_create(linode_id, kernel_id, name, disk_list)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.boot",
            "DATA"       => { "ConfigID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
