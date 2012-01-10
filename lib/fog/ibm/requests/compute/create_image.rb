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
        def create_image(instance_id, name, description, extra_params={})
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
          }
          params = {
            'name' => name,
            'description' => description
          }
          options.merge!(Fog::IBM.form_body(params.merge(extra_params)))
          request(options)
        end

      end
    end
  end
end
