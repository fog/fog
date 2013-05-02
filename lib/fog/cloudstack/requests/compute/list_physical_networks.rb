  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists physical networks
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listPhysicalNetworks.html]
          def list_physical_networks(options={})
            options.merge!(
              'command' => 'listPhysicalNetworks'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
