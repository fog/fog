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

          data = request("voxel.images.list", options)

          if data['stat'] == "ok"
            images = data['images']['image']
            images = [ images ] if images.is_a?(Hash)

            images.map { |i| { :id => i['id'], :name => i['summary'] } }
          else
            []
          end
        end
      end

      class Mock
        def images_list( image_id = nil )
          images = [ { :id => 1, :name => "CentOS 5 x64" }, { :id => 2, :name => "Ubuntu 10.04 LTS x64" } ]

          if image_id.nil?
            images
          else
            images.select { |i| i[:id] == image_id }
          end
        end
      end
    end
  end
end
