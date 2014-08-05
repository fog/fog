module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a snapshot policy for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createSnapshotPolicy.html]
        def create_snapshot_policy(intervaltype, volumeid, schedule, maxsnaps, timezone, options={})
          options.merge!(
            'command' => 'createSnapshotPolicy', 
            'intervaltype' => intervaltype, 
            'volumeid' => volumeid, 
            'schedule' => schedule, 
            'maxsnaps' => maxsnaps, 
            'timezone' => timezone  
          )
          request(options)
        end
      end

    end
  end
end

