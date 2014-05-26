module Fog
  module Compute
    class OpenStack
      class Real
        def update_meta(collection_name, parent_id, key, value)
          request(
            :body     => Fog::JSON.encode({ 'meta' => {key => value}}),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "#{collection_name}/#{parent_id}/metadata/#{key}"
          )
        end
      end

      class Mock
        def update_meta(collection_name, parent_id, key, value)
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

          #FIXME join w/ existing metadata here
          response = Excon::Response.new
          response.body = { "metadata" => {key => value} }
          response.status = 200
          response
        end
      end
    end
  end
end
