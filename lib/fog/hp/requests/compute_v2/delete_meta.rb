module Fog
  module Compute
    class HPV2
      class Real
        # Delete metadata item for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intented.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        # * 'key'<~String> - key for the metadata item
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body: Empty response body
        #
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
          if collection_name == "images" then
            if get_image_details(parent_id)
              self.data[:images][parent_id]['metadata'].delete(key)
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          if collection_name == "servers" then
            if get_server_details(parent_id)
              self.data[:servers][parent_id]['metadata'].delete(key)
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
