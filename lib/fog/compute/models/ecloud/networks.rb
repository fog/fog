require 'fog/compute/models/ecloud/network'

module Fog
  module Ecloud
    class Compute

      class Networks < Fog::Ecloud::Collection

        undef_method :create

        model Fog::Ecloud::Compute::Network

        attribute :href

        def all
          check_href!("Vdc")
          if data = connection.get_vdc(href).body[:AvailableNetworks][:Network]
            load(data)
          end
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
