require 'fog/core/collection'
require 'fog/compute/models/ninefold/address'

module Fog
  module Ninefold
    class Compute

      class Addresses < Fog::Collection

        model Fog::Ninefold::Compute::Address

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
