module Fog
  module Terremark
    module Shared

      module Mock
        def networks(options = {})
          Fog::Terremark::Shared::Networks.new(options.merge(:service => self))
        end
      end

      module Real
        def networks(options = {})
          Fog::Terremark::Shared::Networks.new(options.merge(:service => self))
        end
      end

      class Networks < Fog::Collection

        model Fog::Terremark::Shared::Network

        def all
          data = service.get_vdc(vdc_id).body['AvailableNetworks'].map do |network|
            service.get_network(network["href"].split("/").last).body
          end
          load(data)
        end

        def get(network_id)
          if network_id && network = service.get_network(network_id).body
            new(network)
          elsif !network_id
            nil
          end
        rescue Excon::Errors::Forbidden
          nil
        end

        def vdc_id
          @vdc_id ||= service.default_vdc_id
        end

        private

        def vdc_id=(new_vdc_id)
          @vdc_id = new_vdc_id
        end

      end

    end
  end
end
