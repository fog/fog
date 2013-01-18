module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteSnapshotPolicies.html]
        def delete_snapshot_policy(options={})
          options.merge!(
            'command' => 'deleteSnapshotPolicies'
          )

          request(options)
        end

      end
    end
  end
end
