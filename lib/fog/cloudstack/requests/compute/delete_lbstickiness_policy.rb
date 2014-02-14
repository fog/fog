  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a LB stickiness policy.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteLBStickinessPolicy.html]
          def delete_lbstickiness_policy(options={})
            options.merge!(
              'command' => 'deleteLBStickinessPolicy'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
