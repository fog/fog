require 'fog/core/model'

module Fog
  module AWS
    class IAM

      class Role < Fog::Model
        
        identity  :id, :aliases => 'RoleId'
        attribute :rolename, :aliases => 'RoleName'
        attribute :create_date, :aliases => 'CreateDate', :type => :time
        attribute :assume_role_policy_document, :aliases => 'AssumeRolePolicyDocument'
        attribute :arn, :aliases => 'Arn'
        attribute :path, :aliases => 'Path'
        
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :rolename
          requires :assume_role_policy_document
          
          data = service.create_role(rolename, assume_role_policy_document).body["Role"]
          merge_attributes(data)
          true
        end

        def destroy
          requires :rolename
          
          service.delete_role(rolename)
          true
        end

      end
    end
  end
end