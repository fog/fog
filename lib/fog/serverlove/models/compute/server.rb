require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Server < Fog::Model

        identity :server
        
        attribute :server
        attribute :status   
        attribute :user
        attribute :started
        
        def save
           # TODO
        end

        def destroy
          requires :identity
          connection.destroy_server(identity)
          true
        end 
      end
    end
  end
end
