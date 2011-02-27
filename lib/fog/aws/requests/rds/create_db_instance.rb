module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_instance'

        # create a db instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to modify
        #                                     
        # * AllocatedStorage  <~Integer> Storage space, in GB
        # * AutoMinorVersionUpgrade <~Boolean> Indicates that minor version upgrades will be applied automatically to the DB Instance during the maintenance window 
        # * AvailabilityZone <~String> The availability zone to create the instance in
        # * BackupRetentionPeriod  <~Integer> 0-8 The number of days to retain automated backups.
        # * DBInstanceClass <~String> The new compute and memory capacity of the DB Instance
        # * DBName <~String> The name of the database to create when the DB Instance is created
        # * DBParameterGroupName <~String> The name of the DB Parameter Group to apply to this DB Instance  
        # * DBSecurityGroups <~Array> A list of DB Security Groups to authorize on this DB Instance 
        # * Engine <~String> The name of the database engine to be used for this instance.
        # * EngineVersion <~String> The version number of the database engine to use.
        # * MasterUsername <~String> The db master user
        # * MasterUserPassword  <~String> The new password for the DB Instance master user
        # * MultiAZ <~Boolean> Specifies if the DB Instance is a Multi-AZ deployment
        # * Port <~Integer> The port number on which the database accepts connections.
        # * PreferredBackupWindow <~String> The daily time range during which automated backups are created if automated backups are enabled
        # * PreferredMaintenanceWindow <~String> The weekly time range (in UTC) during which system maintenance can occur, which may result in an outage
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_instance(db_name, options={})
          
          if security_groups = options.delete('DBSecurityGroups')
            options.merge!(AWS.indexed_param('DBSecurityGroups.member.%d', [*security_groups]))
          end
    
          request({
            'Action'  => 'CreateDBInstance',
            'DBInstanceIdentifier' => db_name,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBInstance.new,
          }.merge(options))
        end

      end

      class Mock

        def create_db_instance(db_name, options={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
