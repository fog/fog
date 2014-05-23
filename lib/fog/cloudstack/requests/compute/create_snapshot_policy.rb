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
            'maxsnaps' => options['maxsnaps'], 
            'intervaltype' => options['intervaltype'], 
            'volumeid' => options['volumeid'], 
            'schedule' => options['schedule'], 
             
          )
          request(options)
        end
      end

    end
  end
end

