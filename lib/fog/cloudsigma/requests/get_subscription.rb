module Fog
  module Compute
    class CloudSigma
      class Real
        def get_subscription(sub_id)
          get_request("subscriptions/#{sub_id}/")
        end
      end

      class Mock
        def get_subscription(sub_id)
          mock_get(:subscriptions, 200, sub_id)
        end
      end
    end
  end
end
