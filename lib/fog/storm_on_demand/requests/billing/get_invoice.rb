module Fog
  module Billing
    class StormOnDemand
      class Real
        def get_invoice(options={})
          request(
            :path => '/Billing/Invoice/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
