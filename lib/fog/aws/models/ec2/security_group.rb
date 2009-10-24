module Fog
  module AWS
    class EC2

      class SecurityGroup < Fog::Model

        identity  :group_name,        'groupName'

        attribute :group_description, 'groupDescription'
        attribute :ip_permissions,    'ipPermissions'
        attribute :owner_id,          'ownerId'

        def authorize(options = {})
          options = {
            'GroupName' => @group_name
          }.merge!(options)
          connection.authorize_security_group_ingress(options)
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
