module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/describe_db_instances'

        # Describe all or specified load db instances
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DescribeDBInstances.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - ID of instance to retrieve information for. if absent information for all instances is returned
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_db_instances(identifier=nil, opts={})
          params = {}
          params['DBInstanceIdentifier'] = identifier if identifier
          if opts[:marker]
            params['Marker'] = opts[:marker]
          end
          if opts[:max_records]
            params['MaxRecords'] = opts[:max_records]
          end
          
          request({
            'Action'  => 'DescribeDBInstances',
            :parser   => Fog::Parsers::AWS::RDS::DescribeDBInstances.new
          }.merge(params))
        end

      end

      class Mock

        def describe_db_instances(identifier=nil, opts={})
          response = Excon::Response.new
          if identifier
            if self.data[:servers].has_key?(identifier)
              servers_set = self.data[:servers][identifier]
              response.status = 200
              response.body = {
                "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
                "DescribeDBInstancesResult" => { "DBInstances" => [servers_set] }
              }
              
              
            else
              response.status = 404
              response.body =  {
                "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
                "DescribeDBInstancesResult" => { "DBInstances" => 'DBInstanceNotFound' }
              }
              raise Fog::AWS::RDS::NotFound.new("DBInstance #{identifier} not found")
            end
            
          else
            servers_set = self.data[:servers].values
            response.status = 200
            response.body = {
              "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
              "DescribeDBInstancesResult" => { "DBInstances" => servers_set }
            }
          end
          response
        end

      end
    end
  end
end
