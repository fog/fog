require 'fog/core/collection'
require 'fog/aws/models/compute/image'

module Fog
  module Compute
    class AWS

      class Images < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::Image
        
        # Creates a new Amazon machine image
        #
        # AWS.images.new
        #
        # ==== Returns
        #
        # Returns the details of the new image
        #
        #>> AWS.images.new
        #  <Fog::AWS::Compute::Image
        #    id=nil,
        #    architecture=nil,
        #    block_device_mapping=nil,
        #    location=nil,
        #    owner_id=nil,
        #    state=nil,
        #    type=nil,
        #    is_public=nil,
        #    kernel_id=nil,
        #    platform=nil,
        #    product_codes=nil,
        #    ramdisk_id=nil,
        #    root_device_type=nil,
        #    root_device_name=nil,
        #    tags=nil
        #  >
        #
        
        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = connection.describe_images(filters).body
          load(data['imagesSet'])
        end
        
        def get(image_id)
          if image_id
            self.class.new(:connection => connection).all('image-id' => image_id).first
          end
        end
      end

    end
  end
end
