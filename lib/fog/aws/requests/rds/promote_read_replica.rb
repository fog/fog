module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/promote_read_replica'

        # promote a read replica to a writable RDS instance
        # http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_PromoteReadReplica.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - The DB Instance identifier for the DB Instance to be deleted.
        # * BackupRetentionPeriod <~Integer> - The number of days to retain automated backups. Range: 0-8.
        #                         Setting this parameter to a positive number enables backups.
        #                         Setting this parameter to 0 disables automated backups.
        # * PreferredBackupWindow <~String> - The daily time range during which automated backups are created if
        #                         automated backups are enabled, using the BackupRetentionPeriod parameter.
        #                         Default: A 30-minute window selected at random from an 8-hour block of time per region.
        # See the Amazon RDS User Guide for the time blocks for each region from which the default backup windows are assigned.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:

        def promote_read_replica(identifier, backup_retention_period = nil, preferred_backup_window = nil)
          params = {}
          params['BackupRetentionPeriod'] = backup_retention_period if backup_retention_period
          params['PreferredBackupWindow'] = preferred_backup_window if preferred_backup_window
          request({
            'Action'  => 'PromoteReadReplica',
            'DBInstanceIdentifier' => identifier,
            :parser   => Fog::Parsers::AWS::RDS::PromoteReadReplica.new
          }.merge(params))
        end
      end

      class Mock
        def promote_read_replica(identifier, backup_retention_period = nil, preferred_backup_window = nil)
          if self.data[:servers][identifier]
            data = {
                'BackupRetentionPeriod' => backup_retention_period || 1,
                'PreferredBackupWindow' => preferred_backup_window || '08:00-08:30',
                'DBInstanceIdentifier' => identifier
            }
            self.data[:servers][identifier].merge(data)

            response = Excon::Response.new
            response.body = {
                "ResponseMetadata" => { "RequestId" => Fog::AWS::Mock.request_id },
                "PromoteReadReplicaResult" => { "DBInstance" => data}
            }
            response.status = 200
            response
          else
            raise Fog::AWS::RDS::NotFound.new("DBInstance #{identifier} not found")
          end
        end
      end
    end
  end
end
