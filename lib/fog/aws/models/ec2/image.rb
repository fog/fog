require 'fog/model'

module Fog
  module AWS
    module EC2

      class Image < Fog::Model

        identity :id,             'imageId'

        attribute :architecture
        attribute :location,      'imageLocation'
        attribute :owner_id,      'imageOwnerId'
        attribute :state,         'imageState'
        attribute :type,          'imageType'
        attribute :is_public,     'isPublic'
        attribute :kernel_id,     'kernelId'
        attribute :platform
        attribute :product_codes, 'productCodes'
        attribute :ramdisk_id,    'ramdiskId'

      end

    end
  end
end