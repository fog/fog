module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an network.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createNetwork.html]
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
