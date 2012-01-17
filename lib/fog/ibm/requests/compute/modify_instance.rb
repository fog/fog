module Fog
  module Compute
    class IBM
      class Real

        # Modify an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def modify_instance(instance_id, options={})
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/instances/#{instance_id}",
            :body     => options
          )
        end

      end
    end
  end
end
