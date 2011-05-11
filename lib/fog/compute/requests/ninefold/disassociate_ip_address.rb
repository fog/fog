module Fog
  module Ninefold
    class Compute
      class Real

        def disassociate_ip_address(options = {})
          request('disassociateIpAddress', options, :expects => [200],
                  :response_prefix => 'disassociateipaddressresponse', :response_type => Hash)
        end

      end

      class Mock

        def disassociate_ip_address(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
