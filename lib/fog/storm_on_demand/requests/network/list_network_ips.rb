module Fog
  module Network
    class StormOnDemand
      class Real

        def list_network_ips(options={})
          request(
            :path => '/Network/IP/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
