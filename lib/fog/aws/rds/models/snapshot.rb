require 'fog/core/model'

module Fog
  module AWS
    class RDS

      class Snapshot < Fog::Model

        identity  :id, :aliases => ['DBSnapshotIdentifier', :name]
        attribute  :instance_id, :aliases => 'DBInstanceIdentifier'
        attribute  :created_at, :aliases => 'SnapshotCreateTime', :type => :time
        attribute  :instance_created_at, :aliases => 'InstanceCreateTime', :type => :time
        attribute  :engine, :aliases => 'Engine'
        attribute  :engine_version, :aliases => 'EngineVersion'
        attribute  :master_username, :aliases => 'MasterUsername'
        attribute  :state, :aliases => 'Status'
        attribute  :port, :aliases => 'Port', :type => :integer
        attribute  :allocated_storage, :aliases => 'AllocatedStorage', :type => :integer
        attribute  :availability_zone, :aliases => 'AvailabilityZone'

        def ready?
          state == 'available'
        end

        def destroy
          requires :id

          connection.delete_db_snapshot(id)
          true
        end

        def save
          requires :instance_id
          requires :id

          data = connection.create_db_snapshot(instance_id, id).body['CreateDBSnapshotResult']['DBSnapshot']
          merge_attributes(data)
          true
        end

        def server
          requires :instance_id
          connection.servers.get(instance_id)
        end

      end
    end
  end
end
