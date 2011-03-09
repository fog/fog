module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_snapshots'

        # Describe all or specified db snapshots
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DescribeDBSnapshots.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - ID of instance to retrieve information for. if absent information for all instances is returned
        # * DBSnapshotIdentifier <~String> - ID of snapshot to retrieve information for. if absent information for all snapshots is returned
        # * Marker               <~String> - An optional marker provided in the previous DescribeDBInstances request
        # * MaxRecords           <~Integer> - Max number of records to return (between 20 and 100) 
        # Only one of DBInstanceIdentifier or DBSnapshotIdentifier can be specified
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_snapshots(opts={})
          opts = {'DBSnapshotIdentifier' => opts} if opts.is_a? String
          request({
            'Action'  => 'DescribeDBSnapshots',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBSnapshots.new
          }.merge(opts))
        end

      end

      class Mock

        def describe_db_snapshots(opts={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
