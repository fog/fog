require 'fog/model'

module Fog
  module AWS
    class EC2

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

        def deregister(delete_snapshot = false)
          connection.deregister_image(@id)

          if(delete_snapshot && @root_device_type=="ebs")
            @block_device_mapping.each do |block_device|
              next if block_device["deviceName"] != @root_device_name
              snapshot_id = block_device["snapshotId"]
              snapshot = @connection.snapshots.get(snapshot_id)
              return snapshot.destroy
            end
          end

          return true
        end

      end

    end
  end
end
