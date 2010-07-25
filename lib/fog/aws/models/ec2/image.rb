require 'fog/model'

module Fog
  module AWS
    module EC2

      class Image < Fog::Model

        identity :id,                    'imageId'

        attribute :architecture
        attribute :block_device_mapping, 'blockDeviceMapping'
        attribute :location,             'imageLocation'
        attribute :owner_id,             'imageOwnerId'
        attribute :state,                'imageState'
        attribute :type,                 'imageType'
        attribute :is_public,            'isPublic'
        attribute :kernel_id,            'kernelId'
        attribute :platform
        attribute :product_codes,        'productCodes'
        attribute :ramdisk_id,           'ramdiskId'
        attribute :root_device_type,     'rootDeviceType'
        attribute :root_device_name,     'rootDeviceName'

        def deregister
          connection.deregister_image(@id)
        end

      end

    end
  end
end
