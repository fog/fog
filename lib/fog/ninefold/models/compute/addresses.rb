require 'fog/core/collection'
require 'fog/ninefold/models/compute/address'

module Fog
  module Compute
    class Ninefold

      class Addresses < Fog::Collection

        model Fog::Compute::Ninefold::Address

        def all
          data = connection.list_public_ip_addresses
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.list_public_ip_addresses(:id => identifier)
          if data.empty?
            nil
          else
            new(data[0])
          end
        end

      end

    end
  end
end
