require 'fog/core/model'

module Fog
  module AWS
    class ACS

      class SecurityGroup < Fog::Model

        identity :id, :aliases => 'CacheSecurityGroupName'
        attribute :description, :aliases => 'CacheSecurityGroupDescription'
        attribute :ec2_security_group, :aliases => 'EC2SecurityGroups', :type => :array
        attribute :owner_id, :aliases => 'OwnerId'

        def ready?
          ec2_security_groups.all?{|ingress| ingress['Status'] == 'authorized'}
        end

        def destroy
          requires :id
          connection.delete_cache_security_group(id)
          true
        end

        def save
          requires :id
          requires :description
          connection.create_cache_security_group(id, description)
        end

        def authorize_ec2_group(group_name, group_owner_id=owner_id)
          connection.authorize_ec2_security_group(id, group_name, group_owner_id)
        end

        def revoke_ec2_group(group_name, group_owner_id=owner_id)
          connection.revoke_ec2_security_group(id, group_name, group_owner_id)
        end

      end

    end
  end
end

