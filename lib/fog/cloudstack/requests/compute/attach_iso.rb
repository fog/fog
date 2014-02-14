  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Attaches an ISO to a virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/attachIso.html]
          def attach_iso(options={})
            options.merge!(
              'command' => 'attachIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
