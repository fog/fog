require 'fog/core/collection'
require 'fog/hp/models/network/security_group'

module Fog
  module HP
    class Network
      class SecurityGroups < Fog::Collection
        attribute :filters

        model Fog::HP::Network::SecurityGroup

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          load(service.list_security_groups(non_aliased_filters).body['security_groups'])
        end

        def get(security_group_id)
          if security_group = service.get_security_group(security_group_id).body['security_group']
            new(security_group)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end
      end
    end
  end
end
