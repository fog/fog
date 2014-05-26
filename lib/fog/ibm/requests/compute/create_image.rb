module Fog
  module Compute
    class IBM
      class Real
        # Requests an image to be created from an Instance
        #
        # ==== Parameters
        # * instance_id<~String> - id of instance to save
        # * name<~String> - name of image to be created
        # * description<~String> - description of image to be created
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>: name of new image
        #     * 'createdTime'<~Integer>: epoch time at creation
        #     * 'productCodes'<~Array>:
        #     * 'id'<~String>: id of new image
        #     * 'description'<~String>: description
        #     * 'visibility'<~String>: visibility level ("PRIVATE", etc)
        #     * 'state'<~Integer>: status of image
        def create_image(instance_id, name, description)
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
            :body     => {
              'state'       => 'save',
              'name'        => name,
              'description' => description
            }
          )
        end
      end

      class Mock
        def create_image(instance_id, name, description)
          response = Excon::Response.new
          if instance_exists? instance_id
            image = Fog::IBM::Mock.private_image(name, description)
            self.data[:images][image["id"]] = image
            response.status = 200
            response.body = image
          else
            response.status = 404
          end
          response
        end
      end
    end
  end
end
