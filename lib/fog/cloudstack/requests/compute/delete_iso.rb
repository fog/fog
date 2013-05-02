  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes an ISO file.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteIso.html]
          def delete_iso(options={})
            options.merge!(
              'command' => 'deleteIso'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
