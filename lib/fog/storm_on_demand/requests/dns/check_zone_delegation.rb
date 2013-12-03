module Fog
  module DNS
    class StormOnDemand
      class Real

        def check_zone_delegation(options={})
          request(
            :path => '/Network/DNS/Zone/delegation',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
