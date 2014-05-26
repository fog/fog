module Fog
  module Compute
    class HP
      class Real
        # Set or update metadata item for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intented.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        # * 'key'<~String> - key for the metadata item
        # * 'value'<~String> - value for the metadata item
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * meta<~Hash>: hash of key/value pair for the metadata item updated
        #
        def update_meta(collection_name, parent_id, key, value)
          request(
            :body     => Fog::JSON.encode({ 'meta' => { key => value }}),
            :expects  => 200,
            :method   => 'PUT',
            :path     => "#{collection_name}/#{parent_id}/metadata/#{key}"
          )
        end
      end

      class Mock
        def update_meta(collection_name, parent_id, key, value)
          if collection_name == "images" then
            if get_image_details(parent_id)
              self.data[:images][parent_id]['metadata'][key] = value
            else
              raise Fog::Compute::HP::NotFound
            end
          end

          if collection_name == "servers" then
            if get_server_details(parent_id)
              self.data[:servers][parent_id]['metadata'][key] = value
            else
              raise Fog::Compute::HP::NotFound
            end
          end

          response = Excon::Response.new
          response.body = { "meta" => { key => value } }
          response.status = 200
          response
        end
      end
    end
  end
end
