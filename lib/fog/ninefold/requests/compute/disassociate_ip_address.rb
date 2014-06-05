module Fog
  module Compute
    class Ninefold
      class Real
        def disassociate_ip_address(options = {})
          request('disassociateIpAddress', options, :expects => [200],
                  :response_prefix => 'disassociateipaddressresponse', :response_type => Hash)
        end
      end
    end
  end
end
