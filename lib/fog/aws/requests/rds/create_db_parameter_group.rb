module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_parameter_group'

        # create a database parameter group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBParameterGroup.html
        # ==== Parameters
        # * DBParameterGroupName <~String> - name of the parameter group
        # * DBParameterGroupFamily <~String> - The DB parameter group family name. Current valid values: MySQL5.1 | MySQL5.5
        # * Description <~String> - The description for the DB Parameter Grou
        #                                     
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_parameter_group(group_name, group_family, description)
          
          request({
            'Action'  => 'CreateDBParameterGroup',
            'DBParameterGroupName' => group_name,
            'DBParameterGroupFamily' => group_family,
            'Description' => description,
            
            :parser   => Fog::Parsers::AWS::RDS::CreateDbParameterGroup.new
          })
        end

      end

      class Mock

        def create_db_parameter_group(group_name, group_family, description)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
