module Fog
  module Compute
    class HP
      class Real

        # Create an image from an existing server
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server to create image from
        # * name<~String> - Name of the image
        # * options<~Hash> - A hash of options
        #   * 'ImageType'<~String> - type of the image i.e. Gold
        #   * 'ImageVersion'<~String> - version of the image i.e. 2.0
        #
        # ==== Returns
        # Does not return a response body.

        def create_image(server_id, name, options = {})
          body = { 'createImage' =>
                       { 'name' => name,
                         'metadata' =>
                             { 'ImageType' => options[:image_type],
                               'ImageVersion' => options[:image_version]
                             }
                       }
                 }
          server_action(server_id, body)
        end

      end

      class Mock

        def create_image(server_id, name, options = {})
          response = Excon::Response.new
          response.status = 202
          response
        end

      end
    end
  end
end

