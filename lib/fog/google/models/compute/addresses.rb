require 'fog/core/collection'
require 'fog/google/models/compute/address'

module Fog
  module Compute
    class Google

      class Addresses < Fog::Collection
        model Fog::Compute::Google::Address

        def all(filters = {})
          if filters[:region]
            data = service.list_addresses(filters[:region]).body['items'] || []
          else
            data = []
            service.list_aggregated_addresses.body['items'].each_value do |region|
              data.concat(region['addresses']) if region['addresses']
            end
          end
          load(data)
        end

        def get(identity, region)
          if address = service.get_address(identity, region).body
            new(address)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end

    end
  end
end
