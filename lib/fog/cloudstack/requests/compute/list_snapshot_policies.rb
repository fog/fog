module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists snapshot policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSnapshotPolicies.html]
        def list_snapshot_policies(options={})
          options.merge!(
            'command' => 'listSnapshotPolicies',
            'volumeid' => options['volumeid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

