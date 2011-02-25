module Fog
  module Voxel
    class Compute
      class Real

        require 'fog/compute/parsers/voxel/images_list'

        def images_list(image_id = nil)
          options = {
            :parser     => Fog::Parsers::Voxel::Compute::ImagesList.new,
            :verbosity  => 'compact'
          }

          unless image_id.nil?
            options[:verbosity] = 'extended'
            options[:image_id] = image_id
          end

          data = request("voxel.images.list", options).body

          if data['stat'] == "ok"
            data['images']
          else
            raise Fog::Voxel::Compute::NotFound
          end
        end
      end

    end
  end
end
