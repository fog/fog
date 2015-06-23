require 'fog/core/collection'
require 'fog/openstack/models/identity_v3/group'

module Fog
  module Identity
    class OpenStack
      class V3
        class Groups < Fog::Collection
          model Fog::Identity::OpenStack::V3::Group

          def all(options = {})
            load(service.list_groups(options).body['groups'])
          end

          alias_method :summary, :all

          def find_by_id(id)
            cached_group = self.find { |group| group.id == id }
            return cached_group if cached_group
            group_hash = service.get_group(id).body['group']
            Fog::Identity::OpenStack::V3::group.new(
                group_hash.merge(:service => service))
          end

          def destroy(id)
            group = self.find_by_id(id)
            group.destroy
          end
        end
      end
    end
  end
end
