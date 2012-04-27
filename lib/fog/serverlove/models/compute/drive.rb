require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Drive < Fog::Model

        identity :drive

        attribute :name   
        attribute :user
        attribute :size
        attribute :claimed
        attribute :status
        attribute :encryption_cipher, :aliases => 'encryption:cipher'
        
        def save
          requires :identity
          connection.update_drive(identity, attributes)
          true
        end

        def create(attributes)
          requires :name
          connection.create_drive(attributes)
          true
        end

        def destroy
          requires :identity
          connection.destroy_drive(identity)
          true
        end 
      end
    end
  end
end
