require 'fog/core/collection'
require 'fog/ibm/models/compute/address'

module Fog
  module Compute
    class IBM
      class Addresses < Fog::Collection
        model Fog::Compute::IBM::Address

        def all
          load(service.list_addresses.body['addresses'])
        end

        def get(address_id)
          begin
            address = service.list_addresses.body
            new(address['addresses'].find{|address| address['id'] == address_id.to_s })
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end
      end
    end
  end
end
