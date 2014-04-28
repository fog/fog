module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an network.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/createNetwork.html]
        def create_network(options={})
          options.merge!(
            'command' => 'createNetwork'
          )
          request(options)
        end

      end
    end
  end
end
