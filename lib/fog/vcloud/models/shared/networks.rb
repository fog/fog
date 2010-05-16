module Fog
  module Vcloud
    module Shared

      module Mock
        def networks(options = {})
          Fog::Vcloud::Shared::Networks.new(options.merge(:connection => self))
        end
      end

      module Real
        def networks(options = {})
          Fog::Vcloud::Shared::Networks.new(options.merge(:connection => self))
        end
      end

      class Networks < Fog::Collection

        model Fog::Vcloud::Shared::Network

        def all
          data = connection.get_vdc(vdc_id).body['AvailableNetworks'].map do |network|
            connection.get_network(network["href"].split("/").last).body
          end
          load(data)
        end

        def get(network_id)
          if network_id && network = connection.get_network(network_id).body
            new(network)
          elsif !network_id
            nil
          end
        rescue Excon::Errors::Forbidden
          nil
        end

        def vdc_id
          @vdc_id ||= connection.default_vdc_id
        end

        private

        def vdc_id=(new_vdc_id)
          @vdc_id = new_vdc_id
        end

      end

    end
  end
end
