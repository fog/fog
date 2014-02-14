  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a snapshot policy for the account.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createSnapshotPolicy.html]
          def create_snapshot_policy(options={})
            options.merge!(
              'command' => 'createSnapshotPolicy'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
