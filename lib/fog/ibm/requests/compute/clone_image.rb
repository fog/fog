module Fog
  module Compute
    class IBM
      class Real

        # Clone an image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def clone_image(image_id, name, description, extra_params={})
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}"
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
