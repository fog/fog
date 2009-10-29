module Fog
  module AWS
    class EC2

      class SecurityGroup < Fog::Model

        identity  :group_name,        'groupName'

        attribute :group_description, 'groupDescription'
        attribute :ip_permissions,    'ipPermissions'
        attribute :owner_id,          'ownerId'

        def authorize_group_and_owner(group, owner)
          connection.authorize_security_group_ingress(
            'GroupName'                   => @group_name,
            'SourceSecurityGroupName'     => group,
            'SourceSecurityGroupOwnerId'  => owner
          )
        end

        def authorize_port_range(range, options = {})
          connection.authorize_security_group_ingress(
            'CidrIp'      => options[:cidr_ip] || '0.0.0.0/0',
            'FromPort'    => range.min,
            'GroupName'   => @group_name,
            'ToPort'      => range.max,
            'IpProtocol'  => options[:ip_protocol] || 'tcp' 
          )
        end

        def destroy
          connection.delete_security_group(@group_name)
          true
        end

        def save
          data = connection.create_security_group(@group_name, @group_description).body
          true
        end

      end

    end
  end
end
