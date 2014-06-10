module Fog
  module Billing
    class StormOnDemand
      class Real
        def make_payment(options={})
          request(
            :path => '/Billing/Payment/make',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
