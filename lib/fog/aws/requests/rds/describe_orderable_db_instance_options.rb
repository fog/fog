module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_orderable_db_instance_options'

        # Describe all or specified load db instances
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DescribeDBInstances.html
        # ==== Parameters
        # * Engine <~String> - The name of the engine to retrieve DB Instance options for. Required.
        # * Options <~Hash> - Hash of options. Optional. The following keys are used:
        #   * :db_instance_class <~String> - Filter available offerings matching the specified DB Instance class. Optional.
        #   * :engine_version <~String> - Filters available offerings matching the specified engine version. Optional.
        #   * :license_model <~String> - Filters available offerings matching the specified license model. Optional.
        #   * :marker <~String> - The pagination token provided in the previous request. If this parameter is specified the response includes only records beyond the marker, up to MaxRecords. Optional.
        #   * :max_records <~Integer> - The maximum number of records to include in the response. If more records exist, a pagination token is included in the response. Optional.
        #   * :vpc <~Boolean> - Filter to show only the available VPC or non-VPC offerings. Optional.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_orderable_db_instance_options(engine=nil, opts={})
          params = {}
          params['Engine'] = engine if engine
          params['DBInstanceClass'] = opts[:db_instance_class] if opts[:db_instance_class]
          params['EngineVersion'] = opts[:engine_version] if opts[:engine_version]
          params['LicenseModel'] = opts[:license_model] if opts[:license_model]
          params['Marker'] = opts[:marker] if opts[:marker]
          params['MaxRecords'] = opts[:max_records] if opts[:max_records]
          params['Vpc'] = opts[:vpc] if opts[:vpc]

          request({
            'Action'  => 'DescribeOrderableDBInstanceOptions',
            :parser   => Fog::Parsers::AWS::RDS::DescribeOrderableDBInstanceOptions.new
          }.merge(params))
        end

      end

      class Mock

        def describe_orderable_db_instance_options(engine=nil, opts={})
          response = Excon::Response.new
          if engine
            # set up some mock data here...
          else
            raise Fog::AWS::RDS::NotFound.new('An engine must be specified to retrieve orderable instance options')
          end

          response.status = 200
          response.body = {
              'ResponseMetadata' => { 'RequestId' => Fog::AWS::Mock.request_id },
              'DescribeOrderableDBInstanceOptionsResult' => { 'OrderableDBInstanceOptions' => [] }
          }
          response
        end

      end
    end
  end
end
