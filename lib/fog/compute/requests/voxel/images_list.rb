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
          data['images']['image'].map { |i| { :id => i['id'], :name => i['summary'] } }
        end
      end

      class Mock
        def images_list
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
