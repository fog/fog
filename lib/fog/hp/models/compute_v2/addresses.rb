require 'fog/core/collection'
require 'fog/hp/models/compute_v2/address'

module Fog
  module Compute
    class HPV2
      class Addresses < Fog::Collection
        model Fog::Compute::HPV2::Address

        def all
          data = service.list_addresses.body['floating_ips']
          load(data)
        end

        def get(address_id)
          if address = service.get_address(address_id).body['floating_ip']
            new(address)
          end
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
