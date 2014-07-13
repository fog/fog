module Fog
  module Compute
    class Linode
      class Real
        def linode_config_delete(linode_id, config_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.config.delete',
              :linodeId => linode_id,
              :configId => config_id
            }
          )
        end
      end

      class Mock
        def linode_config_delete(linode_id, config_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.config.delete",
            "DATA"       => { "ConfigID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
