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
        def create_instance(name, image_id, instance_type, location, public_key=nil, options={})
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/instances',
            :body     => {
              'name'         => name,
              'imageID'      => image_id,
              'instanceType' => instance_type,
              'location'     => location,
              'publicKey'    => public_key
            }.merge(options)
          )
        end

      end
    end
  end
end
