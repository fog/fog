module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a snapshot policy for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createSnapshotPolicy.html]
        def create_snapshot_policy(options={})
          options.merge!(
            'command' => 'createSnapshotPolicy', 
            'timezone' => options['timezone'], 
            'volumeid' => options['volumeid'], 
            'intervaltype' => options['intervaltype'], 
            'schedule' => options['schedule'], 
            'maxsnaps' => options['maxsnaps']  
          )
          request(options)
        end
      end

    end
  end
end

