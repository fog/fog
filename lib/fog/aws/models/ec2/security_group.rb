module Fog
  module AWS
    class EC2

      class SecurityGroup < Fog::Model

        attribute :group_description, 'groupDescription'
        attribute :group_name,        'groupName'
        attribute :ip_permissions,    'ipPermissions'
        attribute :owner_id,          'ownerId'

        def authorize(options = {})
          options = {
            'GroupName' => @name
          }.merge!(options)
          connection.authorize_security_group_ingress(options)
        end

        def destroy
          connection.delete_security_group(@group_name)
          true
        end

        def reload
          if new_security_group = security_groups.get(@group_name)
            merge_attributes(new_security_group.attributes)
          end
        end

        def save
          data = connection.create_security_group(@group_name, @group_description).body
          true
        end

        def security_groups
          @security_groups
        end

        private

        def security_groups=(new_security_groups)
          @security_groups = new_security_groups
        end

      end

    end
  end
end
