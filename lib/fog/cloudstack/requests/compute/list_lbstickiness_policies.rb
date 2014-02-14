  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists LBStickiness policies.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listLBStickinessPolicies.html]
          def list_lbstickiness_policies(options={})
            options.merge!(
              'command' => 'listLBStickinessPolicies'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
