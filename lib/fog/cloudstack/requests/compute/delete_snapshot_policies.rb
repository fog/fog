module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes snapshot policies for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteSnapshotPolicies.html]
        def delete_snapshot_policies(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteSnapshotPolicies') 
          else
            options.merge!('command' => 'deleteSnapshotPolicies')
          end
          request(options)
        end
      end

    end
  end
end

