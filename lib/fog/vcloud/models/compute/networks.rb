require 'fog/vcloud/models/compute/network'

module Fog
  module Vcloud
    class Compute

      class Networks < Fog::Vcloud::Collection

        undef_method :create

        model Fog::Vcloud::Compute::Network

        attribute :href

        def all
          self.href = connection.default_vdc_href unless self.href
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
