module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/delete_db_snapshot'

        # delete a database snapshot
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DeleteDBSnapshot.html
        # ==== Parameters
        # * DBSnapshotIdentifier <~String> - name of the snapshot
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def delete_db_snapshot(group_name)
          
          request({
            'Action'  => 'DeleteDBSnapshot',
            'DBSnapshotIdentifier' => group_name,
            
            :parser   => Fog::Parsers::AWS::RDS::DeleteDBSnapshot.new
          })
        end

      end

      class Mock

        def delete_db_snapshot(group_name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
