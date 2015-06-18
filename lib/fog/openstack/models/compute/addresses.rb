require 'fog/core/collection'
require 'fog/openstack/models/compute/address'

module Fog
  module Compute
    class OpenStack
      class Addresses < Fog::Collection
        model Fog::Compute::OpenStack::Address

        def all(options = {})
          load(service.list_all_addresses(options).body['floating_ips'])
        end

        alias_method :summary, :all

        def get(address_id)
          if address = service.get_address(address_id).body['floating_ip']
            new(address)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

        def get_address_pools
          service.list_address_pools.body['floating_ip_pools']
        end
      end
    end
  end
end
