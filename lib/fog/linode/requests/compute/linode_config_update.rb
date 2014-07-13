module Fog
  module Compute
    class Linode
      class Real
        # api docs say LinodeID is optional, turns out its required
        def linode_config_update(linode_id, config_id, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { 
              :api_action => 'linode.config.update', 
              :configId => config_id,
              :linodeID => linode_id
            }.merge!(options)
          )
        end
      end

      class Mock
        def linode_config_update(linode_id, config_id, options={})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.config.update",
            "DATA"       => { "ConfigID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
