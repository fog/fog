require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Disk < Fog::Model

        identity :id

        attribute :name   
        attribute :user
        attribute :status
        attribute :tags
        attribute :size
        attribute :claimed?
        attribute :claim_type
        attribute :imaging?
        attribute :readers
        attribute :encryption_cipher
        
        def save
           # TODO
        end

        def destroy
          requires :identity
          connection.destroy_disk(identity)
          true
        end 
      end
    end
  end
end
