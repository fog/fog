require 'fog/ecloudv2/models/compute/network'

module Fog
  module Compute
    class Ecloudv2
      class Networks < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Network

        def all
          data = connection.get_networks(href).body[:Network]
          load(data)
        end

        def get(uri)
          if data = connection.get_network(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
