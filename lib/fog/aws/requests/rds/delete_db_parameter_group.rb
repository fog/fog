module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/delete_db_parameter_group'

        # delete a database parameter group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_DeleteDBParameterGroup.html
        # ==== Parameters
        # * DBParameterGroupName <~String> - name of the parameter group. Must not be associated with any instances
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def delete_db_parameter_group(group_name)
          
          request({
            'Action'  => 'DeleteDBParameterGroup',
            'DBParameterGroupName' => group_name,
            
            :parser   => Fog::Parsers::AWS::RDS::DeleteDbParameterGroup.new
          })
        end

      end

      class Mock

        def delete_db_parameter_group(group_name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
