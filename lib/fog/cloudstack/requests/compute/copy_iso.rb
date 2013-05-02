  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Copies a template from one zone to another.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/copyIso.html]
          def copy_iso(options={})
            options.merge!(
              'command' => 'copyIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
