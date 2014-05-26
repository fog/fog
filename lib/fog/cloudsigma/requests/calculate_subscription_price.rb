module Fog
  module Compute
    class CloudSigma
      class Real
        def calculate_subscription_price(data)
          create_request("subscriptioncalculator/", data)
        end
      end

      class Mock
        def calculate_subscription_price(data)
        end
      end
    end
  end
end
