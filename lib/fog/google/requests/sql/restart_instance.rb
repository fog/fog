module Fog
  module Google
    class SQL
      ##
      # Restarts a Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/restart

      class Real
        def restart_instance(instance_id)
          api_method = @sql.instances.restart
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def restart_instance(instance_id)
          operation = self.random_operation
          self.data[:operations][instance_id] ||= {}
          self.data[:operations][instance_id][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => instance_id,
            'operation' => operation,
            'operationType' => 'RESTART',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesRestart',
            'operation' => operation,
          }

          build_excon_response(body)
        end
      end
    end
  end
end
