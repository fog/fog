module Fog
  module Compute
    class HP
      class Real

        # List all images
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        #     * 'updated'<~String> - Last update timestamp for image
        #     * 'created'<~String> - Creation timestamp for image
        #     * 'status'<~String> - Status of image
        def list_images_detail
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images/detail.json'
          )
        end

      end

      class Mock

        def list_images_detail
          response = Excon::Response.new

          images = self.data[:images].values
          for image in images
            case image['status']
            when 'SAVING'
              if Time.now - self.data[:last_modified][:images][image['id']] >= Fog::Mock.delay
                image['status'] = 'ACTIVE'
              end
            end
          end

          response.status = [200, 203][rand(1)]
          response.body = { 'images' => images.map {|image| image.reject {|key, value| !['id', 'name', 'links', 'metadata', 'progress' ,'status', 'created', 'updated'].include?(key)}} }
          response
        end

      end
    end
  end
end
