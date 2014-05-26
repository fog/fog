module Fog
  module Compute
    class Linode
      class Real
        def linode_update(linode_id, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.update', :linodeId => linode_id }.merge!(options)
          )
        end
      end

      class Mock
        def linode_update(linode_id, options={})
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.update",
            "DATA"       => { "LinodeID" => rand(1000..9999) }
          }
          response
        end
      end
    end
  end
end
