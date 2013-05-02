  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a Pod.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updatePod.html]
          def update_pod(options={})
            options.merge!(
              'command' => 'updatePod'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
