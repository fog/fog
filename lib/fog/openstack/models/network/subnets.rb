require 'fog/core/collection'
require 'fog/openstack/models/network/subnet'

module Fog
  module Network
    class OpenStack
      class Subnets < Fog::Collection
        attribute :filters

        model Fog::Network::OpenStack::Subnet

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          load(service.list_subnets(filters).body['subnets'])
        end

        def get(subnet_id)
          if subnet = service.get_subnet(subnet_id).body['subnet']
            new(subnet)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
