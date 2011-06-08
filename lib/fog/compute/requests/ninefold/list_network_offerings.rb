module Fog
  module Ninefold
    class Compute
      class Real

        def list_network_offerings(options = {})
          request('listNetworkOfferings', options, :expects => [200],
                  :response_prefix => 'listnetworkofferingsresponse/networkoffering', :response_type => Array)
        end

      end
    end
  end
end
