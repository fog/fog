module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createSnapshotPolicy.html]
        def create_snapshot_policy(options={})
          options.merge!(
            'command' => 'createSnapshotPolicy'
          )

          request(options)
        end

      end
    end
  end
end
