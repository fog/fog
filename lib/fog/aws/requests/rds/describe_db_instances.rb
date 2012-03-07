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
          server_set = []
          if identifier
            if server = self.data[:servers][identifier]
              server_set << server
            else
              raise Fog::AWS::RDS::NotFound.new("DBInstance #{identifier} not found")
            end
          else
            server_set = self.data[:servers].values
          end

          server_set.each do |server|
             case server["DBInstanceStatus"]
             when "creating"
                 if Time.now - server['InstanceCreateTime'] >= Fog::Mock.delay * 2
                   region = "us-east-1"
                   server["DBInstanceStatus"] = "available"
                   server["AvailabilityZone"] = region + 'a'
                   server["Endpoint"] = {"Port"=>3306, 
                                         "Address"=> Fog::AWS::Mock.rds_address(server["DBInstanceIdentifier"],region) }
                   server["PendingModifiedValues"] = {}
                 end
              when "rebooting" # I don't know how to show rebooting just once before it changes to available
                # it applies pending modified values
                if server["PendingModifiedValues"]
                  server.merge!(server["PendingModifiedValues"])
                  server["PendingModifiedValues"] = {}
                  self.data[:tmp] ||= Time.now + Fog::Mock.delay * 2
                  if self.data[:tmp] <= Time.now
                    server["DBInstanceStatus"] = 'available'
                    self.data.delete(:tmp)
                  end
                end
              when "modifying"
                # TODO there are some fields that only applied after rebooting
                if server["PendingModifiedValues"]
                  server.merge!(server["PendingModifiedValues"])
                  server["PendingModifiedValues"] = {}
                  server["DBInstanceStatus"] = 'available'
                end
              when "available" # I'm not sure if amazon does this
                if server["PendingModifiedValues"]
                  server["DBInstanceStatus"] = 'modifying'
                end

             end
          end

          response.status = 200
          response.body = {
            "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
            "DescribeDBInstancesResult" => { "DBInstances" => server_set }
          }
          response
        end


      end
    end
  end
end
