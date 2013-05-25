module Fog
  module VPN
    class StormOnDemand
      class Real

        def get_vpn(options={})
          request(
            :path => '/VPN/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
