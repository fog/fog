module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/modify_db_parameter_group'

        # modifies a database parameter group
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_ModifyDBParameterGroup.html
        # ==== Parameters
        # * DBParameterGroupName <~String> - name of the parameter group
        # * Parameters<~Array> - Array of up to 20 Hashes describing parameters to set
        #   * 'ParameterName'<~String> - parameter name.
        #   * 'ParameterValue'<~String> - new paremeter value
        #   * 'ApplyMethod'<~String> - immediate | pending-reboot whether to set the parameter immediately or not (may require an instance restart)
        #                                     
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def modify_db_parameter_group(group_name, parameters)
          
          parameter_names = []
          parameter_values = []
          parameter_apply_methods = []
          
          parameters.each do |parameter|
            parameter_names.push(parameter['ParameterName'])
            parameter_values.push(parameter['ParameterValue'])
            parameter_apply_methods.push(parameter['ApplyMethod'])
          end
          params = {}
          params.merge!(Fog::AWS.indexed_param('Parameters.member.%d.ParameterName', parameter_names))
          params.merge!(Fog::AWS.indexed_param('Parameters.member.%d.ParameterValue', parameter_values))
          params.merge!(Fog::AWS.indexed_param('Parameters.member.%d.ApplyMethod', parameter_apply_methods))
          
          request({
            'Action'  => 'ModifyDBParameterGroup',
            'DBParameterGroupName' => group_name,
            
            :parser   => Fog::Parsers::AWS::RDS::ModifyDbParameterGroup.new
          }.merge(params))
        end

      end

      class Mock

        def modify_db_parameter_group(group_name, parameters)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
