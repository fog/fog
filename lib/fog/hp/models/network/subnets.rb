require 'fog/core/collection'
require 'fog/hp/models/network/subnet'

module Fog
  module HP
    class Network
      class Subnets < Fog::Collection
        attribute :filters

        model Fog::HP::Network::Subnet

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          load(service.list_subnets(non_aliased_filters).body['subnets'])
        end

        def get(subnet_id)
          if subnet = service.get_subnet(subnet_id).body['subnet']
            new(subnet)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end
      end
    end
  end
end
