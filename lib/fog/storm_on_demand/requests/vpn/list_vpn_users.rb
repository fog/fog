module Fog
  module VPN
    class StormOnDemand
      class Real

        def list_vpn_users(options={})
          request(
            :path => '/VPN/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
