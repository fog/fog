module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available networks.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworks.html]
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

