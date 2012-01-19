require 'fog/core/model'
require 'fog/ibm/models/compute/instance-types'

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

        def initialize(new_attributes = {})
          super(new_attributes)
          attributes[:supported_instance_types] = Fog::Compute::IBM::InstanceTypes.new.load(attributes[:supported_instance_types]) if attributes[:supported_instance_types]
        end

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
