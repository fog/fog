module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_parameter_groups'

        # This API returns a list of DBParameterGroup descriptions. If a DBParameterGroupName is specified, the list will contain only the descriptions of the specified DBParameterGroup
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DescribeDBParameterGroups.html
        # ==== Parameters
        # * DBParameterGroupName <~String> - The name of a specific database parameter group to return details for.
        # * Source <~String> - The parameter types to return. user | system | engine-default
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_parameter_groups(name=nil, opts={})
          params={}
          if opts[:marker]
            params['Marker'] = opts[:marker]
          end
          if name
            params['DBParameterGroupName'] = name
          end
          if opts[:max_records]
            params['MaxRecords'] = opts[:max_records]
          end
          
          request({
            'Action'  => 'DescribeDBParameterGroups',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBParameterGroups.new
          }.merge(params))
        end

      end

      class Mock

        def describe_db_parameter_groups(name=nil, opts={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
