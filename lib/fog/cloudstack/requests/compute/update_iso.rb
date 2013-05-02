  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates an ISO file.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateIso.html]
          def update_iso(options={})
            options.merge!(
              'command' => 'updateIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
