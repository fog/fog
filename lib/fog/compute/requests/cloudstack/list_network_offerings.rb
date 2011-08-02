module Fog
  module Compute
    class Cloudstack
      class Real

        def list_network_offerings(options={})
          options.merge!(
            'command' => 'listNetworkOfferings'
          )
          
          request(options)
        end

      end
    end
  end
end
