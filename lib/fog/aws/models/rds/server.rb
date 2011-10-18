require 'fog/core/model'

module Fog
  module AWS
    class RDS

      class Server < Fog::Model

        identity  :id, :aliases => 'DBInstanceIdentifier'
        attribute :engine, :aliases => 'Engine'
        attribute :engine_version, :aliases => 'EngineVersion'
        attribute :state, :aliases => 'DBInstanceStatus'
        attribute :allocated_storage, :aliases => 'AllocatedStorage', :type => :integer
        attribute :availability_zone , :aliases => 'AvailabilityZone'
        attribute :flavor_id, :aliases => 'DBInstanceClass'
        attribute :endpoint, :aliases => 'Endpoint'
        attribute :read_replica_source, :aliases => 'ReadReplicaSourceDBInstanceIdentifier'
        attribute :read_replica_identifiers, :aliases => 'ReadReplicaDBInstanceIdentifiers', :type => :array
        attribute :master_username, :aliases => 'MasterUsername'
        attribute :multi_az, :aliases => 'MultiAZ'
        attribute :created_at, :aliases => 'InstanceCreateTime', :type => :time
        attribute :last_restorable_time, :aliases => 'LatestRestorableTime', :type => :time
        attribute :auto_minor_version_upgrade, :aliases => 'AutoMinorVersionUpgrade'
        attribute :pending_modified_values, :aliases => 'PendingModifiedValues'
        attribute :preferred_backup_window, :aliases => 'PreferredBackupWindow'
        attribute :preferred_maintenance_window, :aliases => 'PreferredMaintenanceWindow'
        attribute :db_name, :aliases => 'DBName'
        attribute :db_security_groups, :aliases => 'DBSecurityGroups', :type => :array
        attribute :db_parameter_groups, :aliases => 'DBParameterGroups'
        attribute :backup_retention_period, :aliases => 'BackupRetentionPeriod', :type => :integer
        attribute :license_model, :aliases => 'LicenseModel'

        attr_accessor :password, :parameter_group_name, :security_group_names, :port

        def create_read_replica(replica_id, options={})
          options[:security_group_names] ||= options['DBSecurityGroups']
          params = self.class.new(options).attributes_to_params
          connection.create_db_instance_read_replica(replica_id, id, params)
          connection.servers.get(replica_id)
        end

        def ready?
          state == 'available'
        end

        def destroy(snapshot_identifier=nil)
          requires :id
          connection.delete_db_instance(id, snapshot_identifier, snapshot_identifier.nil?)
          true
        end

        def reboot
          connection.reboot_db_instance(id)
          true
        end

        def snapshots
          requires :id
          connection.snapshots(:server => self)
        end

        def modify(immediately, options)
          options[:security_group_names] ||= options['DBSecurityGroups']
          params = self.class.new(options).attributes_to_params
          data = connection.modify_db_instance(id, immediately, params)
          merge_attributes(data.body['ModifyDBInstanceResult']['DBInstance'])
          true
        end

        def save
          requires :engine
          requires :allocated_storage
          requires :master_username
          requires :password

          self.flavor_id ||= 'db.m1.small'

          data = connection.create_db_instance(id, attributes_to_params)
          merge_attributes(data.body['CreateDBInstanceResult']['DBInstance'])
          true
        end

        # Converts attributes to a parameter hash suitable for requests
        def attributes_to_params
          options = {
            'AllocatedStorage'              => allocated_storage,
            'AutoMinorVersionUpgrade'       => auto_minor_version_upgrade,
            'BackupRetentionPeriod'         => backup_retention_period,
            'DBName'                        => db_name,
            'DBParameterGroupName'          => parameter_group_name || attributes['DBParameterGroupName'],
            'DBSecurityGroups'              => security_group_names,
            'DBInstanceIdentifier'          => id,
            'AvailabilityZone'              => availability_zone,
            'DBInstanceClass'               => flavor_id,
            'Port'                          => port || attributes['Port'],
            'Engine'                        => engine,
            'EngineVersion'                 => engine_version,
            'MasterUsername'                => master_username,
            'MasterUserPassword'            => password || attributes['MasterUserPassword'],
            'PreferredMaintenanceWindow'    => preferred_maintenance_window,
            'PreferredBackupWindow'         => preferred_backup_window,
            'MultiAZ'                       => multi_az,
            'LicenseModel'                  => license_model
          }

          options.delete_if {|key, value| value.nil?}
        end
      end
    end
  end
end
