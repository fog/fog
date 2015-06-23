require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/os_credential'

module Fog
  module Identity
    class OpenStack
      class V3
        class OsCredentials < Fog::Collection
          model Fog::Identity::OpenStack::V3::OsCredential

          def all(options = {})
            load(service.list_os_credentials(options).body['credentials'])
          end

          alias_method :summary, :all

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
