module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists snapshot policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSnapshotPolicies.html]
        def list_snapshot_policies(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSnapshotPolicies') 
          else
            options.merge!('command' => 'listSnapshotPolicies', 
            'volumeid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

