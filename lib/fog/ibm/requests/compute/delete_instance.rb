module Fog
  module Compute
    class IBM
      class Real

        # Terminate an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def delete_instance(instance_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/instances/#{instance_id}"
          )
        end

      end
    end
  end
end
