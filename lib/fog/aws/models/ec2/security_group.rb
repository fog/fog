module Fog
  module AWS
    class EC2

      class SecurityGroup < Fog::Model

        attribute :group_description, 'groupDescription'
        attribute :group_name,        'groupName'
        attribute :ip_permissions,    'ipPermissions'
        attribute :owner_id,          'ownerId'

        def destroy
          connection.delete_security_group(@group_name)
          true
        end

        def reload
          new_attributes = security_groups.all(@public_ip).first.attributes
          merge_attributes(new_attributes)
        end

        def save
          data = connection.create_create_security_group(@group_name, @group_description).body
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
