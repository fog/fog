module Fog
  module Google
    class SQL
      ##
      # Restores a backup of a Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/restoreBackup

      class Real
        def restore_instance_backup(identity, backup_configuration, due_time)
          api_method = @sql.instances.reset_ssl_config
          parameters = {
            'project' => @project,
            'instance' => identity,
            'backupConfiguration' => backup_configuration,
            'dueTime' => due_time,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def restore_instance_backup(identity, backup_configuration, due_time)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
