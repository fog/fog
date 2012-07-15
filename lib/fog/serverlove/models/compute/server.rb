require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Server < Fog::Model

        identity :id, :aliases => 'server'
        
        attribute :name
        attribute :cpu
        attribute :persistent
        attribute :vnc_password, :aliases => 'vnc:password'
        attribute :status   
        attribute :user
        attribute :started
        
        def save
          attributes = {}
          
          if(identity)
            attributes = connection.update_server(identity, allowed_attributes).body
          else
            requires :name
            requires :cpu
            attributes = connection.create_server(allowed_attributes).body
          end
          
          merge_attributes(attributes)
          self
        end

        def destroy
          requires :identity
          connection.destroy_server(identity)
          self
        end
        
        def allowed_attributes
          allowed = [:name, :cpu, :persistent, :vnc_password]
          attributes.select {|k,v| allowed.include? k}
        end
      end
    end
  end
end
