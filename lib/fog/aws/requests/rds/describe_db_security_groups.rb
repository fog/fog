module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_security_groups'

        # Describe all or specified db snapshots
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_DescribeDBSecurityGroups.html
        # ==== Parameters
        # * DBSecurityGroupName <~String> - The name of the DB Security Group to return details for.
        # * Marker               <~String> - An optional marker provided in the previous DescribeDBInstances request
        # * MaxRecords           <~Integer> - Max number of records to return (between 20 and 100)
        # Only one of DBInstanceIdentifier or DBSnapshotIdentifier can be specified
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_security_groups(opts={})
          opts = {'DBSecurityGroupName' => opts} if opts.is_a?(String)

          request({
            'Action'  => 'DescribeDBSecurityGroups',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBSecurityGroups.new
          }.merge(opts))
        end

      end

      class Mock

        def describe_db_security_group(opts={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end

