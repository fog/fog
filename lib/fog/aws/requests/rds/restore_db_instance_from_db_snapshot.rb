module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/restore_db_instance_from_db_snapshot'

        # Restores a DB Instance from a DB Snapshot
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_RestoreDBInstanceFromDBSnapshot.html
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def restore_db_instance_from_db_snapshot(snapshot_id, db_name, opts={})
          request({
            'Action'  => 'RestoreDBInstanceFromDBSnapshot',
            'DBSnapshotIdentifier' => snapshot_id,
            'DBInstanceIdentifier' => db_name,
            :parser   => Fog::Parsers::AWS::RDS::RestoreDBInstanceFromDBSnapshot.new,
          }.merge(opts))
        end
      end

      class Mock
        def restore_db_instance_from_db_snapshot(snapshot_id, db_id, options={})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
