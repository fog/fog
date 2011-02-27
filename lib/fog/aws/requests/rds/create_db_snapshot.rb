module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_snapshot'

        # creates a db snapshot
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBSnapshot.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - ID of instance to create snapshot for
        # * DBSnapshotIdentifier <~String> - The identifier for the DB Snapshot. 1-255 alphanumeric or hyphen characters. Must start with a letter
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_snapshot(identifier, name)
          request({
            'Action'  => 'CreateDBSnapshot',
            'DBInstanceIdentifier' => identifier,
            'DBSnapshotIdentifier' => name,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBSnapshot.new
          })
        end

      end

      class Mock

        def create_db_snapshot(identifier, name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
