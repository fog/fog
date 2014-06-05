module Fog
  module Billing
    class StormOnDemand
      class Real
        def next_invoice(options={})
          request(
            :path => '/Billing/Invoice/next',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
