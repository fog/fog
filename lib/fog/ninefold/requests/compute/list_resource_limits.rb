module Fog
  module Compute
    class Ninefold
      class Real
        def list_resource_limits(options = {})
          request('listResourceLimits', options, :expects => [200],
                  :response_prefix => 'listresourcelimitsresponse/resourcelimit', :response_type => Array)
        end
      end
    end
  end
end
