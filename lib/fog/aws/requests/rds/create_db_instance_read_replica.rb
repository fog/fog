module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_instance_read_replica'

        # create a read replica db instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstanceReadReplica.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to create
        # * SourceDBInstanceIdentifier <~String> - name of the db instance that will be the source. Must have backup retention on
        # * AutoMinorVersionUpgrade <~Boolean> Indicates that minor version upgrades will be applied automatically to the DB Instance during the maintenance window 
        # * AvailabilityZone <~String> The availability zone to create the instance in
        # * DBInstanceClass <~String> The new compute and memory capacity of the DB Instance
        # * Port <~Integer> The port number on which the database accepts connections.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_instance_read_replica(instance_identifier, source_identifier, options={})
          
    
          request({
            'Action'  => 'CreateDBInstanceReadReplica',
            'DBInstanceIdentifier' => instance_identifier,
            'SourceDBInstanceIdentifier' => source_identifier,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBInstanceReadReplica.new,
          }.merge(options))
        end

      end

      class Mock

        def create_db_instance_read_replica(instance_identifier, source_identifier, options={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
