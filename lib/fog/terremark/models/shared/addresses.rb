module Fog
  module Terremark
    module Shared

      module Mock
        def addresses(options = {})
          Fog::Terremark::Shared::Addresses.new(options.merge(:service => self))
        end
      end

      module Real
        def addresses(options = {})
          Fog::Terremark::Shared::Addresses.new(options.merge(:service => self))
        end
      end

      class Addresses < Fog::Collection

        model Fog::Terremark::Shared::Address

        def all
          load(service.get_public_ips(vdc_id).body['PublicIpAddresses'])
        end

        def get(ip_id)
          if ip_id && ip = service.get_public_ip(ip_id).body
            new(ip)
          elsif !ip_id
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
