module Fog
  module VPN
    class StormOnDemand
      class Real
        def create_vpn(options={})
          request(
            :path => '/VPN/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
