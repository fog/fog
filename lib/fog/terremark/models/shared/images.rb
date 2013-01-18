require 'fog/core/collection'
require 'fog/terremark/models/shared/image'

module Fog
  module Terremark
    module Shared


      module Mock
        def images(options = {})
          Fog::Terremark::Shared::Images.new(options.merge(:service => self))
        end
      end

      module Real
        def images(options = {})
          Fog::Terremark::Shared::Images.new(options.merge(:service => self))
        end
      end

      class Images < Fog::Collection


        model Fog::Terremark::Shared::Image

        def all
          data = service.get_catalog(vdc_id).body['CatalogItems'].select do |entity|
            entity['type'] == "application/vnd.vmware.vcloud.catalogItem+xml"
          end
          load(data)
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
