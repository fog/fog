module Fog
  module Voxel
    class Compute
      class Real
        def images_list( image_id = nil )
          options = { :verbosity => 'compact' }

          unless image_id.nil?
            options[:verbosity] = 'extended'
            options[:image_id] = image_id
          end

          data = request("voxel.images.list", options, Fog::Parsers::Voxel::Compute::ImagesList.new).body

          if data[:stat] == "ok"
            data[:images]
          else
            raise Fog::Voxel::Compute::NotFound
          end
        end
      end

      class Mock
        def images_list( image_id = nil )
          if image_id.nil?
            @data[:images]
          else
            selected = @data[:images].select { |i| i[:id] == image_id }
            
            if selected.empty?
              raise Fog::Voxel::Compute::NotFound
            else
              selected
            end
          end
        end
      end
    end
  end
end
