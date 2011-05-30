module Fog
  module Ninefold
    class Compute
      class Real

        def associate_ip_address(options = {})
          request('associateIpAddress', options, :expects => [200],
                  :response_prefix => 'associateipaddressresponse', :response_type => Hash)
        end

      end
    end
  end
end
