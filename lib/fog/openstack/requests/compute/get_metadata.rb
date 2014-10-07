module Fog
  module Compute
    class OpenStack
      class Real
        def get_metadata(collection_name, parent_id, key)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "#{collection_name}/#{parent_id}/metadata/#{key}"
          )
        end
      end

      class Mock
        def get_metadata(collection_name, parent_id, key)
          response = Excon::Response.new
          response.status = 200
          response.body = { 'meta' => {} }
          response
        end
      end
    end
  end
end
