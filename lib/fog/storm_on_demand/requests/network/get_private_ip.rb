module Fog
  module Network
    class StormOnDemand
      class Real
        def get_private_ip(options={})
          request(
            :path => '/Network/Private/getIP',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
