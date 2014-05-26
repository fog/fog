module Fog
  module Compute
    class Linode
      class Real
        def linode_shutdown(linode_id)
          request(
            :expects => 200,
            :method => 'GET',
            :query => { :api_action => 'linode.shutdown', :linodeId => linode_id }
          )
        end
      end

      class Mock
        def linode_shutdown(linode_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.shutdown",
            "DATA"       => { "JobID" => rand(1000..9999) }
          }
          response
        end
      end
    end
  end
end
