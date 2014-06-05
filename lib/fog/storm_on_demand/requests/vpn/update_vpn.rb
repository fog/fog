module Fog
  module VPN
    class StormOnDemand
      class Real
        def update_vpn(options={})
          request(
            :path => '/VPN/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
