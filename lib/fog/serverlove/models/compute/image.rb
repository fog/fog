require 'fog/core/model'

module Fog
  module Compute
    class Serverlove
      class Image < Fog::Model
        identity :id, :aliases => 'drive'

        attribute :name
        attribute :user
        attribute :size
        attribute :claimed
        attribute :status
        attribute :imaging
        attribute :encryption_cipher, :aliases => 'encryption:cipher'

        def save
          attributes = {}

          if(identity)
            attributes = service.update_image(identity, allowed_attributes).body
          else
            requires :name
            requires :size
            attributes = service.create_image(allowed_attributes).body
          end

          merge_attributes(attributes)
          self
        end

        def load_standard_image(standard_image_uuid)
          requires :identity
          service.load_standard_image(identity, standard_image_uuid)
        end

        def ready?
          status.upcase == 'ACTIVE'
        end

        def destroy
          requires :identity
          service.destroy_image(identity)
          self
        end

        def allowed_attributes
          allowed = [:name, :size]
          attributes.select {|k,v| allowed.include? k}
        end
      end
    end
  end
end
