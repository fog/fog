module Fog
  module Compute
    class Ninefold
      class Real

        def list_public_ip_addresses(options = {})
          request('listPublicIpAddresses', options, :expects => [200],
                  :response_prefix => 'listpublicipaddressesresponse/publicipaddress', :response_type => Hash)
        end

      end
    end
  end
end
