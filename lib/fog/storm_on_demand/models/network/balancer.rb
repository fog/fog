require 'fog/core/model'

module Fog
  module Network
    class StormOnDemand

      class Balancer < Fog::Model

        identity :uniq_id

        attribute :capabilities
        attribute :name
        attribute :nodes
        attribute :region_id
        attribute :services
        attribute :session_persistence
        attribute :ssl_includes
        attribute :ssl_termination
        attribute :strategy
        attribute :vip

        def initialize(attributes={})
          super
        end

        def add_node(options)
          requires :identity
          service.add_balancer_node({:uniq_id => identity}.merge!(options))
        end

        def remove_node(options)
          requires :identity
          service.remove_balancer_node({:uniq_id => identity}.merge!(options))
        end

        def add_service(options)
          requires :identity
          service.add_balancer_service({:uniq_id => identity}.merge!(options))
        end

        def remove_service(options)
          requires :identity
          service.remove_balancer_service({:uniq_id => identity}.merge!(options))
        end

        def destroy
          requires :identity
          service.delete_balancer({:uniq_id => identity})
        end

        def update(options)
          requires :identity
          service.update_balancer({:uniq_id => identity}.merge!(options))
        end

      end

    end
  end
end
