require 'fog/core/model'

module Fog
  module Voxel
    class Compute

      class BlockInstantiationError < StandardError; end

      class Server < Fog::Model

        identity :id

        attribute :name
        attribute :processing_cores
        #attribute :image_id        # id or name
        #attribute :ip
        attribute :status
        attribute :facility

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id
          connection.voxcloud_delete(id)
          true
        end

        def image
          requires :image_id
          connection.images_list(image_id)
        end

        def ready?
          @status == 'SUCCEEDED'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :image_id, :processing_cores, :facility

          options = { :hostname => name, :image_id => 16, :processing_cores => processing_cores, :facility => facility }

          data = connection.voxcloud_create(options)

          merge_attributes(data)

          true
        end

      end

    end

  end
end
