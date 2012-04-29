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
          connection.update_drive(identity, allowed_attributes)
          true
        end

        def create(attributes)
          requires :name
          requires :size
          attributes = Fog::Compute::Serverlove::Drive.new(attributes).allowed_attributes
          Fog::Compute::Serverlove::Drive.new(connection.create_drive(attributes).body)
        end

        def destroy
          requires :identity
          connection.destroy_drive(identity)
          true
        end
        
        def allowed_attributes
          allowed = [:name, :size]
          attributes.select {|k,v| allowed.include? k}
        end

      end
    end
  end
end
