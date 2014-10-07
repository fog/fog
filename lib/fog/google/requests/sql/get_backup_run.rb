module Fog
  module Google
    class SQL
      ##
      # Retrieves a resource containing information about a backup run
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/backupRuns/get

      class Real
        def get_backup_run(instance_id, backup_configuration_id, due_time)
          api_method = @sql.backup_runs.get
          parameters = {
            'project' => @project,
            'instance' => instance_id,
            'backupConfiguration' => backup_configuration_id,
            'dueTime' => due_time,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_backup_run(instance_id, backup_configuration_id, due_time)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
