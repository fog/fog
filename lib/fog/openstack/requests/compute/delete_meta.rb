module Fog
  module Compute
    class OpenStack
      class Real

        def delete_meta(collection_name, parent_id, key)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "#{collection_name}/#{parent_id}/metadata/#{key}"
          )
        end

      end

      class Mock

        def delete_meta(collection_name, parent_id, key)
          response = Excon::Response.new
          response.status = 204
          response
        end

      end

    end
  end
end
