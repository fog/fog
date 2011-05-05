module Fog
  module Ninefold
    class Compute
      class Real

        def list_resource_limits(options = {})
          request('listResourceLimits', options, :expects => [200],
                  :response_prefix => 'listresourcelimitsresponse/resourcelimit', :response_type => Array)
        end

      end

      class Mock

        def list_resource_limits(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
