require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Disk < Fog::Model

        identity :drive

        attribute :name   
        attribute :user
        attribute :size
        attribute :claimed
        attribute :status
        attribute :encryption:cipher
        
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
