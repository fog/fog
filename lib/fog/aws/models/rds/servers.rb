require 'fog/core/collection'
require 'fog/aws/models/rds/server'

module Fog
  module AWS
    class RDS

      class Servers < Fog::Collection

        model Fog::AWS::RDS::Server

        def all
          data = connection.describe_db_instances.body['DescribeDBInstancesResult']['DBInstances']
          load(data) # data is an array of attribute hashes
        end

        def get(identity)
          data = connection.describe_db_instances(identity).body['DescribeDBInstancesResult']['DBInstances'].first
          new(data) # data is an attribute hash
        rescue Fog::AWS::RDS::NotFound
          nil
        end

      end
    end
  end
end