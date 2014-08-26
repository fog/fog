module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a snapshot policy for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createSnapshotPolicy.html]
        def create_snapshot_policy(options={})
          request(options)
        end


        def create_snapshot_policy(volumeid, maxsnaps, timezone, intervaltype, schedule, options={})
          options.merge!(
            'command' => 'createSnapshotPolicy', 
            'volumeid' => volumeid, 
            'maxsnaps' => maxsnaps, 
            'timezone' => timezone, 
            'intervaltype' => intervaltype, 
            'schedule' => schedule  
          )
          request(options)
        end
      end

    end
  end
end

