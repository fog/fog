require 'fog/core/model'

module Fog
  module AWS
    class RDS
      
      class ParameterGroup < Fog::Model

        identity  :id, :aliases => ['DBParameterGroupName', :name]
        attribute  :family, :aliases => 'DBParameterGroupFamily'
        attribute  :description, :aliases => 'Description'
        
        def save
          requires :family
          requires :description
          requires :id
          connection.create_db_parameter_group(id, family, description)
        end
        
        def modify(changes)
          connection.modify_db_parameter_group id, changes.collect {|c| {'ParameterName' => c[:name], 'ParameterValue' => c[:value], 'ApplyMethod' => c[:apply_method]}}
        end
        
        def destroy
          requires :id
          connection.delete_db_parameter_group(id)
          true
        end
        
        def parameters(filters={})
          connection.parameters({:group => self}.merge(filters))
        end
      end
    end
  end
end