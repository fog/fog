module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_engine_versions'
       
        def describe_db_engine_versions(opts={})
          params = {}
          params['DBParameterGroupFamily'] = opts[:db_parameter_group_family] if opts[:db_parameter_group_family]
          params['DefaultOnly'] = opts[:default_only] if opts[:default_only]
          params['Engine'] = opts[:engine] if opts[:engine]
          params['EngineVersion'] = opts[:engine_version] if opts[:engine_version]
          params['Marker'] = opts[:marker] if opts[:marker]
          params['MaxRecords'] = opts[:max_records] if opts[:max_records]
          
          request({
            'Action'  => 'DescribeDBEngineVersions',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBEngineVersions.new
          }.merge(params))
        end

      end

      class Mock

        def describe_db_engine_versions(opts={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
