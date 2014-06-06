module Fog
  module Network
    class StormOnDemand
      class Real
        def get_ip_details(options={})
          request(
            :path => '/Network/IP/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
