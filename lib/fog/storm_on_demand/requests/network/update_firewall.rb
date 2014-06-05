module Fog
  module Network
    class StormOnDemand
      class Real
        def update_firewalls(options={})
          request(
            :path => '/Network/Firewall/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
