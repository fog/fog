module Fog
  module DNS
    class StormOnDemand
      class Real

        def list_zones(options={})
          request(
            :path => '/Network/DNS/Zone/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
