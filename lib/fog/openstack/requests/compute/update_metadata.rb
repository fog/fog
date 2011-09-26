module Fog
  module Compute
    class OpenStack

      class Real

        def update_metadata(collection_name, parent_id, metadata = {})
          request(
            :body     => MultiJson.encode({ 'metadata' => metadata }),
            :expects  => 200,
            :method   => 'POST',
            :path     => "#{collection_name}/#{parent_id}/metadata.json"
          )
        end

      end

      class Mock

        def update_metadata(collection_name, parent_id, metadata = {})

          if collection_name == "images" then
            if not list_images_detail.body['images'].detect {|_| _['id'] == parent_id}
              raise Fog::Compute::OpenStack::NotFound
            end 
          end

          if collection_name == "servers" then
            if not list_servers_detail.body['servers'].detect {|_| _['id'] == parent_id}
              raise Fog::Compute::OpenStack::NotFound
            end 
          end

          #FIXME join w/ existing metadata here
          response = Excon::Response.new
          response.body = { "metadata" => metadata }
          response.status = 200
          response

        end

      end

    end
  end
end
