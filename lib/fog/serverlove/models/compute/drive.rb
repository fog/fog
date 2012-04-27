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
        attribute :encryption_cipher
        
        def save
           # TODO
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
