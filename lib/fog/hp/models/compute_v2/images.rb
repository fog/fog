require 'fog/core/collection'
require 'fog/hp/models/compute_v2/image'

module Fog
  module Compute
    class HPV2
      class Images < Fog::Collection
        attribute :filters

        model Fog::Compute::HPV2::Image

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_images_detail(non_aliased_filters).body['images']
          else
            data = service.list_images(non_aliased_filters).body['images']
          end
          load(data)
          self
        end

        def get(image_id)
          data = service.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
