module Fog
  module Network
    class StormOnDemand
      class Real

        def remove_ip_from_server(options={})
          request(
            :path => '/Network/IP/remove',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
