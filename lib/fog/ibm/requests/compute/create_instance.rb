module Fog
  module Compute
    class IBM
      class Real

        # Create an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_instance(name, image_id, instance_type, location, extra_params={})
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => '/instances'
          }
          params = {
            'name' => name,
            'imageID' => image_id,
            'instanceType' => instance_type,
            'location' => location
          }
          options.merge!(Fog::IBM.form_body(params.merge(extra_params)))
          request(options)
        end

      end
    end
  end
end
