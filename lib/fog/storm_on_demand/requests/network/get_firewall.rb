module Fog
  module Network
    class StormOnDemand
      class Real
        def get_firewall(options={})
          request(
            :path => '/Network/Firewall/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
