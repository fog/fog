require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v3/os_credential'

module Fog
  module Identity
    class OpenStack
      class V3
        class OsCredentials < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V3::OsCredential

          def all(options = {})
            load_response(service.list_os_credentials(options), 'credentials')
          end

          def find_by_id(id)
            cached_credential = self.find { |credential| credential.id == id }
            return cached_credential if cached_credential
            credential_hash = service.get_os_credential(id).body['credential']
            Fog::Identity::OpenStack::V3::Credential.new(
                credential_hash.merge(:service => service))
          end

          def destroy(id)
            credential = self.find_by_id(id)
            credential.destroy
          end
        end
      end
    end
  end
end
