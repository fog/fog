module Fog
  module DNS
    class StormOnDemand
      class Real

        def create_zone(options={})
          request(
            :path => '/Network/DNS/Zone/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
