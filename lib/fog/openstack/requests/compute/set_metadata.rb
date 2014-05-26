module Fog
  module Compute
    class OpenStack
      class Real
        def set_metadata(collection_name, parent_id, metadata = {})
          request(
            :body     => Fog::JSON.encode({ 'metadata' => metadata }),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "#{collection_name}/#{parent_id}/metadata"
          )
        end
      end

      class Mock
        def set_metadata(collection_name, parent_id, metadata = {})
          if collection_name == "images" then
            if not list_images_detail.body['images'].find {|_| _['id'] == parent_id}
              raise Fog::Compute::OpenStack::NotFound
            end
          end

          if collection_name == "servers" then
            if not list_servers_detail.body['servers'].find {|_| _['id'] == parent_id}
              raise Fog::Compute::OpenStack::NotFound
            end
          end

          response = Excon::Response.new
          response.body = { "metadata" => metadata }
          response.status = 200
          response
        end
      end
    end
  end
end
