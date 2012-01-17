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
    end
  end
end
