  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Extracts an ISO
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/extractIso.html]
          def extract_iso(options={})
            options.merge!(
              'command' => 'extractIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
