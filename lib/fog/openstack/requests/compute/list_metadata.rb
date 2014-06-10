module Fog
  module Compute
    class OpenStack
      class Real
        def list_metadata(collection_name, parent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/#{collection_name}/#{parent_id}/metadata.json"
          )
        end
      end

      class Mock
        def list_metadata(collection_name, parent_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {}
          response
        end
      end
    end
  end
end
