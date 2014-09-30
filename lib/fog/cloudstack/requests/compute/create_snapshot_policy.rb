module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a snapshot policy for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createSnapshotPolicy.html]
        def create_snapshot_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createSnapshotPolicy') 
          else
            options.merge!('command' => 'createSnapshotPolicy', 
            'volumeid' => args[0], 
            'maxsnaps' => args[1], 
            'timezone' => args[2], 
            'intervaltype' => args[3], 
            'schedule' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

