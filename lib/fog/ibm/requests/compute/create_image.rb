module Fog
  module Compute
    class IBM
      class Real

        # Create an image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_image(instance_id, name, description)
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
            :body     => {
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
