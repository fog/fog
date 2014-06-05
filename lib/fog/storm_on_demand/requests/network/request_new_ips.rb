module Fog
  module Network
    class StormOnDemand
      class Real
        def request_new_ips(options={})
          request(
            :path => '/Network/IP/request',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
