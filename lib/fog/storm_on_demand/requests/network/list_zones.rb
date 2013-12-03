module Fog
  module Network
    class StormOnDemand
      class Real

        def list_zones(options={})
          request(
            :path => '/Network/Zone/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
