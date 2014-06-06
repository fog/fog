module Fog
  module Network
    class StormOnDemand
      class Real
        def get_firewall_rules(options={})
          request(
            :path => '/Network/Firewall/rules',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
