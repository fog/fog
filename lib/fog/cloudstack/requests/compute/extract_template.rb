  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Extracts a template
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/extractTemplate.html]
          def extract_template(options={})
            options.merge!(
              'command' => 'extractTemplate'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
