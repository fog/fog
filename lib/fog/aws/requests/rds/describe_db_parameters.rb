module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/describe_db_parameters'

        # Describe  parameters from a parameter group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DescribeDBParameters.html
        # ==== Parameters
        # * DBParameterGroupName <~String> - name of parameter group to retrieve parameters for
        # * Source <~String> - The parameter types to return. user | system | engine-default
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_parameters(name, opts={})
          params={}
          if opts[:marker]
            params['Marker'] = opts[:marker]
          end
          if opts[:source]
            params['Source'] = opts[:source]
          end
          if opts[:max_records]
            params['MaxRecords'] = opts[:max_records]
          end

          request({
            'Action'  => 'DescribeDBParameters',
            'DBParameterGroupName' => name,
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBParameters.new
          }.merge(params))
        end
      end

      class Mock
        def describe_db_parameters(name, opts={})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
