require 'fog/core/collection'
require 'fog/google/models/sql/backup_run'

module Fog
  module Google
    class SQL
      class BackupRuns < Fog::Collection
        model Fog::Google::SQL::BackupRun

        ##
        # Lists all backup runs associated with a given instance and configuration
        #
        # @param [String] instance_id Instance ID
        # @param [String] backup_configuration_id Backup Configuration ID
        # @return [Array<Fog::Google::SQL::BackupRun>] List of Backup run resources
        def all(instance_id, backup_configuration_id)
          data = service.list_backup_runs(instance_id, backup_configuration_id).body['items'] || []
          load(data)
        end

        ##
        # Retrieves a resource containing information about a backup run
        #
        # @param [String] instance_id Instance ID
        # @param [String] backup_configuration_id Backup Configuration ID
        # @param [String] due_time The time when this run is due to start in RFC 3339 format
        # @return [Fog::Google::SQL::BackupRun] Backup run resource
        def get(instance_id, backup_configuration_id, due_time)
          if backup_run = service.get_backup_run(instance_id, backup_configuration_id, due_time).body
            new(backup_run)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
