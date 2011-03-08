module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/delete_db_security_group'

        # deletes a db security group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_DeleteDBSecurityGroup.html
        # ==== Parameters
        # * DBSecurityGroupName <~String> - The name for the DB Security Group to delete
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def delete_db_security_group(name)
          request({
            'Action'  => 'DeleteDBSecurityGroup',
            'DBSecurityGroupName' => name,
            :parser   => Fog::Parsers::AWS::RDS::DeleteDBSecurityGroup.new
          })
        end

      end

      class Mock

        def delete_db_security_group(name, description = name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end


