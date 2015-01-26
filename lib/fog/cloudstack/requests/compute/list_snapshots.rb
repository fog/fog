module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available snapshots for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listSnapshots.html]
        def list_snapshots(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listSnapshots')
          else
            options.merge!('command' => 'listSnapshots')
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
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

