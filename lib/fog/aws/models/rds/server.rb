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
        attribute :iops, :aliases => 'Iops'
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
        attribute :db_subnet_group_name, :aliases => 'DBSubnetGroupName'
        attribute :publicly_accessible, :aliases => 'PubliclyAccessible'
        attribute :vpc_security_groups, :aliases => 'VpcSecurityGroups', :type => :array

        attr_accessor :password, :parameter_group_name, :security_group_names, :port

        def create_read_replica(replica_id, options={})
          options[:security_group_names] ||= options['DBSecurityGroups']
          params = self.class.new(options).attributes_to_params
          service.create_db_instance_read_replica(replica_id, id, params)
          service.servers.get(replica_id)
        end

        def ready?
          state == 'available'
        end

        def destroy(snapshot_identifier=nil)
          requires :id
          service.delete_db_instance(id, snapshot_identifier, snapshot_identifier.nil?)
          true
        end

        def reboot
          service.reboot_db_instance(id)
          true
        end

        def snapshots
          requires :id
          service.snapshots(:server => self)
        end

        def tags
          requires :id
          service.list_tags_for_resource(id).
            body['ListTagsForResourceResult']['TagList']
        end

        def add_tags(new_tags)
          requires :id
          service.add_tags_to_resource(id, new_tags)
          tags
        end

        def remove_tags(tag_keys)
          requires :id
          service.remove_tags_from_resource(id, tag_keys)
          tags
        end

        def promote_read_replica
          requires :id
          service.promote_read_replica(id)
        end

        def modify(immediately, options)
          options[:security_group_names] ||= options['DBSecurityGroups']
          params = self.class.new(options).attributes_to_params
          data = service.modify_db_instance(id, immediately, params)
          merge_attributes(data.body['ModifyDBInstanceResult']['DBInstance'])
          true
        end

        def save
          requires :engine
          requires :allocated_storage
          requires :master_username
          requires :password

          self.flavor_id ||= 'db.m1.small'

          data = service.create_db_instance(id, attributes_to_params)
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
            'Iops'                          => iops,
            'MasterUsername'                => master_username,
            'MasterUserPassword'            => password || attributes['MasterUserPassword'],
            'PreferredMaintenanceWindow'    => preferred_maintenance_window,
            'PreferredBackupWindow'         => preferred_backup_window,
            'MultiAZ'                       => multi_az,
            'LicenseModel'                  => license_model,
            'DBSubnetGroupName'             => db_subnet_group_name,
            'PubliclyAccessible'            => publicly_accessible,
            'VpcSecurityGroups'             => vpc_security_groups,
          }

          options.delete_if {|key, value| value.nil?}
        end
      end
    end
  end
end
