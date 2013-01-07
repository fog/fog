require 'fog/core/model'

module Fog
  module Compute
    class GoGrid

      class Password < Fog::Model

        identity :id

        attribute :server_id
        attribute :applicationtype
        attribute :username
        attribute :password_id,	:aliases => 'id'
        attribute :password
        attribute :server

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id
          service.grid_server_destroy(id)
          true
        end

        def image
          requires :image_id
          service.grid_image_get(image_id)
        end

        def ready?
          @state == 'On'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :password_id
          data = service.support_password_list()
          merge_attributes(data.body)
          true
        end

      end

    end

  end
end
