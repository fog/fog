require 'fog/core/collection'
require 'fog/linode/models/compute/image'

module Fog
  module Compute
    class Linode
      class Images < Fog::Collection
        model Fog::Compute::Linode::Image

        def all
          load images
        end

        def get(id)
          new images(id).first
        rescue Fog::Compute::Linode::NotFound
          nil
        end

        private
        def images(id=nil)
          service.avail_distributions(id).body['DATA'].map { |image| map_image image }
        end

        def map_image(image)
          image = image.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          image.merge!(:id => image[:distributionid], :name => image[:label], :image_size => image[:minimagesize],
                       :requires_pvops_kernel => image[:requirespvopskernel], :bits => ((image[:is64bit] == 1) ? 64 : 32 ),
                       :created_at => image[:create_dt])
        end
      end
    end
  end
end
