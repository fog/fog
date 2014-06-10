module Fog
  module Compute
    class Linode
      class Real
        def linode_boot(linode_id, config_id)
          request(
            :expects => 200,
            :method => 'GET',
            :query => { :api_action => 'linode.boot', :linodeId => linode_id, :configId => config_id }
          )
        end
      end

      class Mock
        def linode_boot(linode_id, config_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.boot",
            "DATA"       => { "JobID" => rand(1000..9999) }
          }
          response
        end
      end
    end
  end
end
