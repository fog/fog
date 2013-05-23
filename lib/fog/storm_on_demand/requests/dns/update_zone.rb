module Fog
  module DNS
    class StormOnDemand
      class Real

        def update_zone(options={})
          request(
            :path => '/Network/DNS/Zone/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
