require 'fog/core/collection'
require 'fog/azure/models/compute/image'

module Fog
  module Compute
    class Azure

      class Images < Fog::Collection
        model Fog::Compute::Azure::Image

        def all()
          images = []
          service.list_images.each do |image|
            hash = {}
            image.instance_variables.each do |var|
              hash[var.to_s.delete("@")] = image.instance_variable_get(var)
            end
            images << hash
          end
          load(images)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        rescue Fog::Errors::NotFound
          nil
        end
        
      end
    end
  end
end
