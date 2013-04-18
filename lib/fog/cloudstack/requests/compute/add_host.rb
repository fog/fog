module Fog
  module Compute
    class Cloudstack
      class Real

        # Adds a cluster.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/addHost.html]
        def add_host(options={})
          options.merge!(
            'command' => 'addHost'
          )
          request(options)
        end

      end
    end
  end
end
