module Fog
  module Google
    class SQL
      ##
      # Lists all backup runs associated with a given instance and configuration in the
      # reverse chronological order of the enqueued time
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/backupRuns/list

      class Real
        def list_backup_runs(instance_id, backup_configuration_id)
          api_method = @sql.backup_runs.list
          parameters = {
            'project' => @project,
            'instance' => instance_id,
            'backupConfiguration' => backup_configuration_id,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_backup_runs(instance_id, backup_configuration_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
