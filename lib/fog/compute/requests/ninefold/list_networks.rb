module Fog
  module Ninefold
    class Compute
      class Real

        def list_networks(options = {})
          request('listNetworks', options, :expects => [200],
                  :response_prefix => 'listnetworksresponse/network', :response_type => Array)
        end

      end
    end
  end
end
