module Fog
  module DNS
    class StormOnDemand
      class Real
        def get_zone(options={})
          request(
            :path => '/Network/DNS/Zone/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
