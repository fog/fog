require 'fog/core/model'

module Fog
  module AWS
    class ACS

      class SecurityGroup < Fog::Model

        identity :id, :aliases => 'CacheSecurityGroupName'
        attribute :description, :aliases => 'CacheSecurityGroupDescription'
        attribute :ec2_groups, :aliases => 'EC2SecurityGroups', :type => :array
        attribute :owner_id, :aliases => 'OwnerId'

        def ready?
          ec2_groups.all?{|ingress| ingress['Status'] == 'authorized'}
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
          requires :id
          requires :owner_id if group_owner_id.nil?
          data = connection.authorize_cache_security_group_ingress(id, group_name, group_owner_id).body['CacheSecurityGroup']
          merge_attributes(data)
        end

        def revoke_ec2_group(group_name, group_owner_id=owner_id)
          requires :id
          requires :owner_id if group_owner_id.nil?
          data = connection.revoke_cache_security_group_ingress(id, group_name, group_owner_id).body['CacheSecurityGroup']
          merge_attributes(data)
        end

      end

    end
  end
end

