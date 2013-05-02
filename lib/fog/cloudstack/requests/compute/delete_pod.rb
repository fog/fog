  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a Pod.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deletePod.html]
          def delete_pod(options={})
            options.merge!(
              'command' => 'deletePod'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
