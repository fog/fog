module Fog
  module Network
    class StormOnDemand
      class Real
        def list_ip_public_accounts(options={})
          request(
            :path => '/Network/IP/listAccntPublic',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
