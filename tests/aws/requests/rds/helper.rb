class AWS

  module RDS

    module Formats

      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      DB_PARAMETER_GROUP = {
          'DBParameterGroupFamily' => String,
          'DBParameterGroupName'=> String,
          'Description'=> String
      }
      CREATE_DB_PARAMETER_GROUP = {
        'ResponseMetadata' => {'RequestId' => String},
        'CreateDBParameterGroupResult' => {
          'DBParameterGroup' => DB_PARAMETER_GROUP
        }
      }

      DB_SECURITY_GROUP = {
        'DBSecurityGroupDescription' => String,
        'DBSecurityGroupName' => String,
        'EC2SecurityGroups' => [Fog::Nullable::Hash],
        'IPRanges' => [Fog::Nullable::Hash],
        'OwnerId' => Fog::Nullable::String
      }

      CREATE_DB_SECURITY_GROUP = BASIC.merge({
        'CreateDBSecurityGroupResult' => {
        'DBSecurityGroup' => DB_SECURITY_GROUP
        }
      })

      AUTHORIZE_DB_SECURITY_GROUP = BASIC.merge({
        'AuthorizeDBSecurityGroupIngressResult' => {
          'DBSecurityGroup' => DB_SECURITY_GROUP
        }
      })

      REVOKE_DB_SECURITY_GROUP = BASIC.merge({
        'RevokeDBSecurityGroupIngressResult' => {
          'DBSecurityGroup' => DB_SECURITY_GROUP
        }
      })

      DESCRIBE_DB_SECURITY_GROUP = BASIC.merge({
        'DescribeDBSecurityGroupsResult' => {
          'DBSecurityGroups' => [DB_SECURITY_GROUP]
        }
      })

      DESCRIBE_DB_PARAMETER_GROUP = {
        'ResponseMetadata' => {'RequestId' => String},
        'DescribeDBParameterGroupsResult' =>{
          'DBParameterGroups' => [DB_PARAMETER_GROUP]
        }
      }

      MODIFY_PARAMETER_GROUP = BASIC.merge({
        'ModifyDBParameterGroupResult' => {
          'DBParameterGroupName' => String
        }
      })


      DB_PARAMETER = {
        'ParameterValue' => Fog::Nullable::String,
        'DataType' => String,
        'AllowedValues' => Fog::Nullable::String,
        'Source' => String,
        'IsModifiable' => Fog::Boolean,
        'Description' => String,
        'ParameterName' => String,
        'ApplyType' => String
      }

      DESCRIBE_DB_PARAMETERS = BASIC.merge({
        'DescribeDBParametersResult' => {
          'Marker' => Fog::Nullable::String,
          'Parameters' => [DB_PARAMETER]
        }

      })

      SNAPSHOT={
        'AllocatedStorage' => Integer,
        'AvailabilityZone' => String,
        'DBInstanceIdentifier' => String,
        'DBSnapshotIdentifier' => String,
        'EngineVersion' => String,
        'Engine' => String,
        'InstanceCreateTime' => Time,
        'MasterUsername' => String,
        'Port' => Integer,
        'SnapshotCreateTime' => Fog::Nullable::Time,
        'Status' => String
      }
      INSTANCE = {
        'AllocatedStorage' => Integer,
        'AutoMinorVersionUpgrade' => Fog::Boolean,
        'AvailabilityZone' => Fog::Nullable::String,
        'BackupRetentionPeriod' => Integer,
        'DBInstanceClass' => String,
        'DBInstanceIdentifier' => String,
        'DBInstanceStatus' => String,
        'DBName' => Fog::Nullable::String,
        'DBParameterGroups' => [{
            'ParameterApplyStatus' => String,
            'DBParameterGroupName' => String
          }],
        'DBSecurityGroups' => [{
            'Status' => String,
            'DBSecurityGroupName' => String
          }],
        'Endpoint' => {
          'Address' => Fog::Nullable::String,
          'Port' => Fog::Nullable::Integer
        },
        'Engine' => String,
        'EngineVersion' => String,
        'InstanceCreateTime' => Fog::Nullable::Time,
        'LatestRestorableTime' => Fog::Nullable::Time,
        'LicenseModel' => String,
        'MasterUsername' => String,
        'MultiAZ' => Fog::Boolean,
        'PendingModifiedValues' => {
          'BackupRetentionPeriod' => Fog::Nullable::Integer,
          'DBInstanceClass'       => Fog::Nullable::String,
          'EngineVersion'         => Fog::Nullable::String,
          'MasterUserPassword'    => Fog::Nullable::String,
          'MultiAZ'               => Fog::Nullable::String,
          'AllocatedStorage'      => Fog::Nullable::Integer,
          'Port'                  => Fog::Nullable::Integer
        },
        'PreferredBackupWindow'=> String,
        'PreferredMaintenanceWindow'=> String,
        'ReadReplicaDBInstanceIdentifiers'=> [String],
        'ReadReplicaDBInstanceIdentifiers'=> [Fog::Nullable::String],
        'ReadReplicaSourceDBInstanceIdentifier'=> Fog::Nullable::String
      }

      CREATE_DB_INSTANCE = BASIC.merge({
        'CreateDBInstanceResult' => {
          'DBInstance' => INSTANCE
        }
      })

      DESCRIBE_DB_INSTANCES = BASIC.merge({
        'DescribeDBInstancesResult' =>  {
          'Marker' => Fog::Nullable::String,
          'DBInstances' => [INSTANCE]
        }
      })

      MODIFY_DB_INSTANCE = BASIC.merge({
        'ModifyDBInstanceResult' => {
          'DBInstance' => INSTANCE
        }
      })

      DELETE_DB_INSTANCE = BASIC.merge({
        'DeleteDBInstanceResult' => {
          'DBInstance' => INSTANCE
        }
      })

      REBOOT_DB_INSTANCE = BASIC.merge({
        'RebootDBInstanceResult' => {
          'DBInstance' => INSTANCE
        }
      })

      CREATE_READ_REPLICA = BASIC.merge({
        'CreateDBInstanceReadReplicaResult' => {
          'DBInstance' => INSTANCE
        }
      })

      CREATE_DB_SNAPSHOT = BASIC.merge({
        'CreateDBSnapshotResult' => {
          'DBSnapshot' => SNAPSHOT
        }
      })

      DESCRIBE_DB_SNAPSHOTS = BASIC.merge({
        'DescribeDBSnapshotsResult' => {
          'Marker' => Fog::Nullable::String,
          'DBSnapshots' => [SNAPSHOT]
        }
      })
      DELETE_DB_SNAPSHOT = BASIC.merge({
        'DeleteDBSnapshotResult' => {
          'DBSnapshot' => SNAPSHOT
        }
      })

    end

  end

end
