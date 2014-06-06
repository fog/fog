module Fog
  module Network
    class StormOnDemand
      class Real
        def get_firewall_basic_options(options={})
          request(
            :path => '/Network/Firewall/getBasicOptions',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
