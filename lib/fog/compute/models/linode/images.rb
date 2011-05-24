require 'fog/core/collection'
require 'fog/compute/models/linode/image'

module Fog
  module Linode
    class Compute
      class Images < Fog::Collection
        model Fog::Linode::Compute::Image

        def all
          load images
        end

        def get(id)
          new images(id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end

        private
        def images(id=nil)
          connection.avail_distributions(id).body['DATA'].map { |image| map_image image }
        end
        
        def map_image(image)
          image = image.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          image.merge!(:id => image[:distributionid], :name => image[:label], :image_size => image[:minimagesize],
                       :kernel_id => image[:requirespvopskernel], :bits => ((image[:is64bit] == 1) ? 64 : 32 ))
        end
      end
    end
  end
end
