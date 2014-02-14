  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Copies a template from one zone to another.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/copyTemplate.html]
          def copy_template(options={})
            options.merge!(
              'command' => 'copyTemplate'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
