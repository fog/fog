module Fog
  module Network
    class StormOnDemand
      class Real
        def set_default_zone(options={})
          request(
            :path => '/Network/Zone/setDefault',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
