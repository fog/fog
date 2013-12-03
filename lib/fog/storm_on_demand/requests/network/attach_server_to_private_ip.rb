module Fog
  module Network
    class StormOnDemand
      class Real

        def attach_server_to_private_ip(options={})
          request(
            :path => '/Network/Private/attach',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
