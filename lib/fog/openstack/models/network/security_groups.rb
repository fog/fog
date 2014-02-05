require 'fog/core/collection'
require 'fog/openstack/models/network/security_group'

module Fog
  module Network
    class OpenStack
      class SecurityGroups < Fog::Collection

        attribute :filters

        model Fog::Network::OpenStack::SecurityGroup

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_security_groups(filters).body['security_groups'])
        end

        def get(security_group_id)
          if security_group = service.get_security_group(security_group_id).body['security_group']
            new(security_group)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end
