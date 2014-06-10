module Fog
  module Network
    class StormOnDemand
      class Real
        def get_zone(options={})
          request(
            :path => '/Network/Zone/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
