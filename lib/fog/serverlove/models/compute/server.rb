require 'fog/core/model'

module Fog
  module Compute
    class Serverlove

      class Server < Fog::Model

        identity :id, :aliases => 'server'
        
        attribute :name
        attribute :cpu
        attribute :mem
        attribute :ide_0_0, :aliases => 'ide:0:0'
        attribute :ide_0_1, :aliases => 'ide:0:1'
        attribute :ide_1_0, :aliases => 'ide:1:0'
        attribute :ide_1_1, :aliases => 'ide:1:1'
        attribute :boot
        attribute :persistent
        attribute :vnc_password, :aliases => 'vnc:password'
        attribute :vnc,       :aliases => 'vnc'
        attribute :status   
        attribute :user
        attribute :started
        attribute :nic_0_model, :aliases => 'nic:0:model'
        attribute :nic_0_dhcp,  :aliases => 'nic:0:dhcp'
        
        def save
          attributes = {}
          
          if(identity)
            attributes = connection.update_server(identity, allowed_attributes).body
          else
            requires :name
            requires :cpu
            attributes = connection.create_server(self.defaults.merge(allowed_attributes)).body
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
          allowed = [:name, :cpu, :mem, :persistent, :vnc_password]
          attributes.select {|k,v| allowed.include? k}
        end
        
        def self.defaults
          { 'nic:0:model' => 'e1000', 'nic:0:dhcp' => 'auto' }
        end
      end
    end
  end
end
