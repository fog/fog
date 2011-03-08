module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_security_group'

        # creates a db security group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_CreateDBSecurityGroup.html
        # ==== Parameters
        # * DBSecurityGroupDescription <~String> - The description for the DB Security Group
        # * DBSecurityGroupName <~String> - The name for the DB Security Group. This value is stored as a lowercase string. Must contain no more than 255 alphanumeric characters or hyphens. Must not be "Default".
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_security_group(name, description = name)
          request({
            'Action'  => 'CreateDBSecurityGroup',
            'DBSecurityGroupName' => name,
            'DBSecurityGroupDescription' => description,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBSecurityGroup.new
          })
        end

      end

      class Mock

        def create_db_security_group(name, description = name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end

