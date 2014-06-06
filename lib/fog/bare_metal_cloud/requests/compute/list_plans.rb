module Fog
  module Compute
    class BareMetalCloud
      class Real
        # List available plans
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'plan'<~Array>
        #       * 'id'<~String>     - Id of the plan
        #       * 'name'<~String>   - Name of the plan
        #       * 'rate'<~String>   - Cost per hour of the plan
        #       * 'os'<~String>     - Operating system of the plan
        #       * 'config'<~String> - Configuration of the plan
        #
        def list_plans
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listPlans'
          )
        end
      end
    end
  end
end
