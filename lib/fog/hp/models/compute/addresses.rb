require 'fog/core/collection'
require 'fog/hp/models/compute/address'

module Fog
  module Compute
    class HP
      class Addresses < Fog::Collection
        model Fog::Compute::HP::Address

        def all
          data = service.list_addresses.body['floating_ips']
          load(data)
        end

        def get(address_id)
          if address = service.get_address(address_id).body['floating_ip']
            new(address)
          end
        rescue Fog::Compute::HP::NotFound
          nil
        end
      end
    end
  end
end
