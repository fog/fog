module Fog
  module Network
    class StormOnDemand
      class Real
        def add_ip_to_server(options={})
          request(
            :path => '/Network/IP/add',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
