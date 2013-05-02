  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all available networks.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listNetworks.html]
          def list_networks(options={})
            options.merge!(
              'command' => 'listNetworks'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
