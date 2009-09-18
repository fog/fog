module Fog
  module AWS
    class EC2

      class SecurityGroup < Fog::Model

        attribute :group_description, 'groupDescription'
        attribute :group_name,        'groupName'
        attribute :ip_permissions,    'ipPermissions'
        attribute :owner_id,          'ownerId'

        def delete
          connection.delete_security_group(@group_name)
          true
        end

        def save
          data = connection.create_create_security_group(@group_name, @group_description).body
          true
        end

        def security_groups
          @security_groups ||= begin
            Fog::AWS::S3::SecurityGroups.new(
              :connection => connection
            )
          end
        end

        private

        def security_groups=(new_security_groups)
          @security_groups = new_security_groups
        end

      end

    end
  end
end
