module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available snapshots for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listSnapshots.html]
        def list_snapshots(options={})
          options.merge!(
            'command' => 'listSnapshots'  
          )
          request(options)
        end
      end
 
      class Mock
        def list_snapshots(options={})
          snapshot_id = options.delete('id')
          if snapshot_id
            snapshots = [self.data[:snapshots][snapshot_id]]
          else
            snapshots = self.data[:snapshots].values
          end

          {
            'listsnapshotsresponse' => {
              'count' => snapshots.size,
              'snapshot' => snapshots
            }
          }
        end
      end 
    end
  end
end

