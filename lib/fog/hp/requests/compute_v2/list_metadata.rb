module Fog
  module Compute
    class HPV2
      class Real
        # List metadata for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intended.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'metadata'<~Hash>: hash of key/value pair for the metadata items found
        #
        def list_metadata(collection_name, parent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "/#{collection_name}/#{parent_id}/metadata"
          )
        end
      end

      class Mock
        def list_metadata(collection_name, parent_id)
          mdata = {}
          if collection_name == "images" then
            if get_image_details(parent_id)
              mdata = self.data[:images][parent_id]['metadata']
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          if collection_name == "servers" then
            if get_server_details(parent_id)
              mdata = self.data[:servers][parent_id]['metadata']
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {'metadata' => mdata}
          response
        end
      end
    end
  end
end
