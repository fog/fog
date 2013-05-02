  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all hypervisor capabilities.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listHypervisorCapabilities.html]
          def list_hypervisor_capabilities(options={})
            options.merge!(
              'command' => 'listHypervisorCapabilities'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
