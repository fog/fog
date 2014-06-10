module Fog
  module DNS
    class StormOnDemand
      class Real
        def renew_domain(options={})
          request(
            :path => '/Network/DNS/Domain/renew',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
