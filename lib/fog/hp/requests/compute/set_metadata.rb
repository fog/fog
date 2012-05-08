module Fog
  module Compute
    class HP
      class Real

        # Set metadata for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intented.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:

        def set_metadata(collection_name, parent_id, metadata = {})
          request(
            :body     => MultiJson.encode({ 'metadata' => metadata }),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "#{collection_name}/#{parent_id}/metadata"
          )
        end

      end

      class Mock

        def set_metadata(collection_name, parent_id, metadata = {})

          if collection_name == "images" then
            if not list_images_detail.body['images'].detect {|_| _['id'] == parent_id}
              raise Fog::Compute::HP::NotFound
            end 
          end

          if collection_name == "servers" then
            if not list_servers_detail.body['servers'].detect {|_| _['id'] == parent_id}
              raise Fog::Compute::HP::NotFound
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
