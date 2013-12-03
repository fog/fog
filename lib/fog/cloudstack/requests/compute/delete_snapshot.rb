module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a specified snapshot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/user/deleteSnapshot.html]
        def delete_snapshot(options={})
          options.merge!(
            'command' => 'deleteSnapshot'
          )

          request(options)
        end

      end

       class Mock

        # Deletes a specified snapashot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/user/deleteSnapshot.html]
        def delete_snapshot(options={})
          snapshot_id = options['id']
          snapshots = self.data[:snapshots]

          if snapshots[snapshot_id]

            snapshots.delete(snapshot_id)
            job_id = add_delete_snapshot_job(snapshot_id)

            {'deletesnapshotresponse' => {'jobid' => job_id}}
          end
          # TODO add cases for empty or wrong id
        end

        def add_delete_snapshot_job(snapshot_id)
          job_id = Fog::Cloudstack.uuid

          job = {
            'id' => job_id,
            'user_id' => self.data[:users].first, # TODO use current user
            'account_id' => self.data[:accounts].first, # TODO use current user
            'cmd' => 'com.cloud.api.commands.DeleteSnapshotCmd',
            'job_status'=> 1,
            'job_result_type' => nil,
            'job_result_code' => 0,
            'job_proc_status' => 0,
            'created_at' => Time.now.iso8601,
            'job_result' => { "success" => true }
          }

          self.data[:jobs][job_id] = job
          job_id
        end

      end
           
    end
  end
end
