require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/domain'

module Fog
  module Identity
    class OpenStack
      class V3
        class Domains < Fog::Collection
          model Fog::Identity::OpenStack::V3::Domain

          def all(options = {})
            load(service.list_domains(options).body['domains'])
          end

          alias_method :summary, :all

          def auth_domains(options = {})
            load(service.auth_domains(options).body['domains'])
          end

          def find_by_id(id)
            cached_domain = self.find { |domain| domain.id == id }
            return cached_domain if cached_domain
            domain_hash = service.get_domain(id).body['domain']
            Fog::Identity::OpenStack::V3::Domain.new(
                domain_hash.merge(:service => service))
          end

          def destroy(id)
            domain = self.find_by_id(id)
            domain.destroy
          end
        end
      end
    end
  end
end
