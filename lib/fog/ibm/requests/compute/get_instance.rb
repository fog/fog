module Fog
  module Compute
    class IBM
      class Real

        # Get an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_instance(instance_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/instances/#{instance_id}"
          )
        end

      end
    end
  end
end
