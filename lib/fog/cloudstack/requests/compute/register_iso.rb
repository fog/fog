  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Registers an existing ISO into the CloudStack Cloud.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/registerIso.html]
          def register_iso(options={})
            options.merge!(
              'command' => 'registerIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
