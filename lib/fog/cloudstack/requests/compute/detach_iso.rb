  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Detaches any ISO file (if any) currently attached to a virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/detachIso.html]
          def detach_iso(options={})
            options.merge!(
              'command' => 'detachIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
