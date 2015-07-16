require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v2/ec2_credential'

module Fog
  module Identity
    class OpenStack
      class V2
        class Ec2Credentials < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V2::Ec2Credential

          attribute :user

          def all(options = {})
            user_id = user ? user.id : nil

            options[:user_id] = user_id
            ec2_credentials = service.list_ec2_credentials(options)

            load_response(ec2_credentials, 'credentials')
          end

          def create(attributes = {})
            if user then
              attributes[:user_id] ||= user.id
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
              response = service.get_ec2_credential(user_id, access_key)
              body = response.body['credential']
              body = body.merge 'service' => service

              ec2_credential = Fog::Identity::OpenStack::V2::EC2Credential.new(body)
            end

            ec2_credential
          end
        end
      end
    end
  end
end
