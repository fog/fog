require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Image < Fog::Model
        identity :id
        attribute :architecture
        attribute :created_at, :aliases => 'createdTime'
        attribute :description
        attribute :documentation
        attribute :location
        attribute :manifest
        attribute :name
        attribute :owner
        attribute :platform
        attribute :product_codes, :aliases => 'productCodes'
        attribute :state
        attribute :supported_instance_types, :aliases => 'supportedInstanceTypes'
        attribute :visibility

        attribute :volume_id

        def save
          requires :id, :volume_id
          data = connection.create_image(id, volume_id)
          merge_attributes(data.body)
          data.body['success']
        end

      end
    end
  end
end
