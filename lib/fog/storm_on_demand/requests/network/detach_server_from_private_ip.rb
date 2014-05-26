module Fog
  module Network
    class StormOnDemand
      class Real
        def detach_server_from_private_ip(options={})
          request(
            :path => '/Network/Private/detach',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
