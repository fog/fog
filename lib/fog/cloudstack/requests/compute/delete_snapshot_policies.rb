  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes snapshot policies for the account.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteSnapshotPolicies.html]
          def delete_snapshot_policies(options={})
            options.merge!(
              'command' => 'deleteSnapshotPolicies'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
