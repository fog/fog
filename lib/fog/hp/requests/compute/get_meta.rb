module Fog
  module Compute
    class HP
      class Real
        # Get metadata item for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intended.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        # * 'key'<~String> - key for the metadata item
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * meta<~Hash>: hash of key/value pair for the metadata item found
        #
        def get_meta(collection_name, parent_id, key)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "#{collection_name}/#{parent_id}/metadata/#{key}"
          )
        end
      end

      class Mock
        def get_meta(collection_name, parent_id, key)
          if collection_name == "images" then
            if get_image_details(parent_id)
              raise Fog::Compute::HP::NotFound unless midata = self.data[:images][parent_id]['metadata'].fetch(key, nil)
            else
              raise Fog::Compute::HP::NotFound
            end
          end

          if collection_name == "servers" then
            if get_server_details(parent_id)
              raise Fog::Compute::HP::NotFound unless midata = self.data[:servers][parent_id]['metadata'].fetch(key, nil)
            else
              raise Fog::Compute::HP::NotFound
            end
          end

          response = Excon::Response.new
          response.status = 200
          response.body = { 'meta' => { key => midata } }
          response
        end
      end
    end
  end
end
