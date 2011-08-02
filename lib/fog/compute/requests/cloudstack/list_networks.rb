module Fog
  module Compute
    class Cloudstack
      class Real

        def list_networks(options={})
          options.merge!(
            'command' => 'listNetworks'
          )
          
          request(options)
        end

      end
    end
  end
end
