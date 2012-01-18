module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/reboot_db_instance'

        # reboots a database instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_RebootDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to reboot
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def reboot_db_instance(instance_identifier)
          request({
            'Action'  => 'RebootDBInstance',
            'DBInstanceIdentifier' => instance_identifier,
            :parser   => Fog::Parsers::AWS::RDS::RebootDBInstance.new,
          })
        end

      end

      class Mock

        def reboot_db_instance(instance_identifier)
          response = Excon::Response.new
          if self.data[:servers][instance_identifier]
            if self.data[:servers][instance_identifier]["DBInstanceStatus"] != "available"
              raise Fog::AWS::RDS::NotFound.new("DBInstance #{instance_identifier} not available for rebooting")
            else
              self.data[:servers][instance_identifier]["DBInstanceStatus"] = 'rebooting'
              response.status = 200
              response.body = {
                "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
                "RebootDBInstanceResult" => { "DBInstance" => self.data[:servers][instance_identifier] }
              }
              response
              
            end
          else
            raise Fog::AWS::RDS::NotFound.new("DBInstance #{instance_identifier} not found")
          end
        end

      end
    end
  end
end
