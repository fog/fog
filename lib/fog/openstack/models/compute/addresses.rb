require 'fog/core/collection'
require 'fog/openstack/models/compute/address'

module Fog
  module Compute
    class OpenStack

      class Addresses < Fog::Collection

        model Fog::Compute::OpenStack::Address

        def all
          load(connection.list_addresses.body['floating_ips'])
        end

        def get(address_id)
          
          if address = connection.get_address(address_id).body['floating_ip']
            new(address)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end

