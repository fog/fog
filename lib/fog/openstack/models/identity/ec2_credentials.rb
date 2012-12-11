require 'fog/core/collection'
require 'fog/openstack/models/identity/ec2_credential'

module Fog
  module Identity
    class OpenStack
      class Ec2Credentials < Fog::Collection
        model Fog::Identity::OpenStack::Ec2Credential

        attribute :user

        def all
          user_id = user ? user.id : nil

          ec2_credentials = connection.list_ec2_credentials(user_id)

          load(ec2_credentials.body['credentials'])
        end

        def create(attributes = {})
          if user then
            attributes[:user_id]   ||= user.id
            attributes[:tenant_id] ||= user.tenant_id
          end

          super attributes
        end

        def destroy(access_key)
          ec2_credential = self.find_by_access_key(access_key)
          ec2_credential.destroy
        end

        def find_by_access_key(access_key)
          user_id = user ? user.id : nil

          ec2_credential =
            self.find { |ec2_credential| ec2_credential.access == access_key }

          unless ec2_credential then
            response = connection.get_ec2_credential(user_id, access_key)
            body = response.body['credential']
            body = body.merge 'connection' => connection

            ec2_credential = Fog::Identity::OpenStack::EC2Credential.new(body)
          end

          ec2_credential
        end
      end
    end
  end
end
