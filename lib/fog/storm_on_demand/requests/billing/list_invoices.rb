module Fog
  module Billing
    class StormOnDemand
      class Real
        def list_invoices(options={})
          request(
            :path => '/Billing/Invoice/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
