  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists snapshot policies.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listSnapshotPolicies.html]
          def list_snapshot_policies(options={})
            options.merge!(
              'command' => 'listSnapshotPolicies'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
