require 'fog/core/collection'
require 'fog/joyent/models/compute/image'

module Fog
  module Compute
    class Joyent
      class Images < Fog::Collection
        model Fog::Compute::Joyent::Image

        def all
          # the API call for getting images changed from 6.5 to 7.0.  Joyent seems to still support the old url, but no idea for how long
          if service.joyent_version.gsub(/[^0-9.]/,'').to_f < 7.0
            load(service.list_datasets.body)
          else
            load(service.list_images.body)
          end
        end

        def get(id)
          data = if service.joyent_version.gsub(/[^0-9.]/,'').to_f < 7.0
            service.get_dataset(id).body
          else
            service.get_image(id).body
          end
          new(data)
        end
      end # Images
    end # Joyent
  end # Compute
end # Fog
