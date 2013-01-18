module Fog
  module Terremark
    module Shared

      module Mock
        def vdcs(options = {})
          Fog::Terremark::Shared::Vdcs.new(options.merge(:service => self))
        end
      end

      module Real
        def vdcs(options = {})
          Fog::Terremark::Shared::Vdcs.new(options.merge(:service => self))
        end
      end

      class Vdcs < Fog::Collection

        model Fog::Terremark::Shared::Vdc

        def all
          data = service.get_organization(organization_id).body['Links'].select do |entity|
            entity['type'] == 'application/vnd.vmware.vcloud.vdc+xml'
          end
          load(data)
        end

        def get(vdc_id)
          if vdc_id && vdc = service.get_vdc(vdc_id).body
            new(vdc)
          elsif !vdc_id
            nil
          end
        rescue Excon::Errors::Forbidden
          nil
        end

        def organization_id
          @vdc_id ||= service.default_organization_id
        end

        private

        def organization_id=(new_organization_id)
          @organization_id = new_organization_id
        end

      end

    end
  end
end
