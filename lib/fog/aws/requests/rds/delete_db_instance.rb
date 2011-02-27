module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/delete_db_instance'

        # delete a database instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DeleteDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - The DB Instance identifier for the DB Instance to be deleted.
        # * FinalDBSnapshotIdentifier <~String> - The DBSnapshotIdentifier of the new DBSnapshot created when SkipFinalSnapshot is set to false
        # * SkipFinalSnapshot <~Boolean> - Determines whether a final DB Snapshot is created before the DB Instance is deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def delete_db_instance(identifier, snapshot_identifier, skip_snapshot = false)          
          params = {}
          params['FinalDBSnapshotIdentifier'] = snapshot_identifier if snapshot_identifier
          request({
            'Action'  => 'DeleteDBInstance',
            'DBInstanceIdentifier' => identifier,
            'SkipFinalSnapshot' => skip_snapshot,            
            :parser   => Fog::Parsers::AWS::RDS::DeleteDBInstance.new
          }.merge(params))
        end

      end

      class Mock

        def delete_db_snapshot(identifier, snapshot_identifier, skip_snapshot = false)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
