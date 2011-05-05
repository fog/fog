module Fog
  module Ninefold
    class Compute
      class Real

        def list_public_ip_addresses(options = {})
          request('listPublicIpAddresses', options, :expects => [200],
                  :response_prefix => 'listpublicipaddressesresponse/publicipaddress', :response_type => Array)
        end

      end

      class Mock

        def list_public_ip_addresses(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
