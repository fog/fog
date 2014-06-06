module Fog
  module Compute
    class CloudSigma
      class Real
        def list_subscriptions
          list_request('subscriptions/')
        end
      end

      class Mock
        def list_subscriptions
          mock_list(:subscriptions, 200)
        end
      end
    end
  end
end
