require 'fog/core/model'

module Fog
  module Storage
    class IBM
      class Volume < Fog::Model
        identity :id
        attribute :location
        attribute :instance_id, :aliases => 'instanceId'
        attribute :owner
        attribute :name
        attribute :format
        attribute :size
        attribute :state
        attribute :storage_area, :aliases => 'storageArea'
        attribute :created_at, :aliases => 'createdTime'
        attribute :product_codes, :aliases => 'productCodes'
        attribute :platform_version, :aliases => 'platformVersion'
        attribute :clone_status, :aliases => 'cloneStatus'

        attribute :offering_id

        def save
          requires :name, :offering_id, :format, :location, :size
          data = connection.create_volume(name, offering_id, format, location, size)
          merge_attributes(data.body)
          data.body['success']
        end

        def destroy
          requires :id
          connection.delete_volume(id)
        end

      end
    end
  end
end
