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
          attributes = {}
          
          if(identity)
            attributes = connection.update_drive(identity, allowed_attributes).body
          else
            requires :name
            requires :size
            attributes = connection.create_drive(allowed_attributes).body
          end
          
          merge_attributes(attributes)
          self
        end

        def destroy
          requires :identity
          connection.destroy_drive(identity)
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
