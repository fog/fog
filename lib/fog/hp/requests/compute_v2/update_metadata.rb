module Fog
  module Compute
    class HPV2
      class Real
        # Update metadata for specific collections
        #
        # ==== Parameters
        # * 'collection_name'<~String> - name of the collection i.e. images, servers for which the metadata is intented.
        # * 'parent_id'<~Integer> - id of the collection i.e. image_id or the server_id
        # * 'metadata'<~Hash> - A hash of key/value pairs containing the metadata

        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'metadata'<~Hash> - all key/value pairs of metadata items merged with existing metadata
        #
        def update_metadata(collection_name, parent_id, metadata = {})
          request(
            :body     => Fog::JSON.encode({ 'metadata' => metadata }),
            :expects  => 200,
            :method   => 'POST',
            :path     => "#{collection_name}/#{parent_id}/metadata"
          )
        end
      end

      class Mock
        def update_metadata(collection_name, parent_id, metadata = {})
          if collection_name == "images" then
            if get_image_details(parent_id)
              newmetadata = self.data[:images][parent_id]['metadata'].merge!(metadata)
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          if collection_name == "servers" then
            if get_server_details(parent_id)
              newmetadata = self.data[:servers][parent_id]['metadata'].merge!(metadata)
            else
              raise Fog::Compute::HPV2::NotFound
            end
          end

          response = Excon::Response.new
          response.body = { "metadata" => newmetadata }
          response.status = 200
          response
        end
      end
    end
  end
end
