require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Balancer < Fog::Model
        
        identity :uniq_id
        
        attribute :vip
        attribute :price
        attribute :name
        attribute :session_persistence
        attribute :ssl_termination
        attribute :strategy
        attribute :nodes
        attribute :services

        def initialize(attributes={})
          super
        end
        
        def add_node(options)
          requires :identity
          connection.add_balancer_node({:uniq_id => identity}.merge!(options))
        end
        
        def remove_node(options)
          requires :identity
          connection.remove_balancer_node({:uniq_id => identity}.merge!(options))
        end
        
        end

    end
  end
end
