require 'fog/core/model'

module Fog
  module Google
    class SQL
      ##
      # A database instance backup run resource
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/backupRuns
      class BackupRun < Fog::Model
        identity :backup_configuration, :aliases => 'backupConfiguration'

        attribute :due_time, :aliases => 'dueTime'
        attribute :end_time, :aliases => 'endTime'
        attribute :enqueued_time, :aliases => 'enqueuedTime'
        attribute :error
        attribute :instance
        attribute :kind
        attribute :start_time, :aliases => 'startTime'
        attribute :status

        DONE_STATE = 'DONE'

        ##
        # Checks if the instance backup run is done
        #
        # @return [Boolean] True if the backup run is done; False otherwise
        def ready?
          self.state == DONE_STATE
        end
      end
    end
  end
end
