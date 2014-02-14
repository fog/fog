  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List system virtual machines.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listSystemVms.html]
          def list_system_vms(options={})
            options.merge!(
              'command' => 'listSystemVms'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
