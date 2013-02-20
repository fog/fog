require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Balancer < Fog::Model

        identity :uniq_id

        attribute :capabilities
        attribute :name
        attribute :nodes
        attribute :region_id, :aliases => ['region']
        attribute :services
        attribute :session_persistence
        attribute :ssl_includes
        attribute :ssl_termination
        attribute :ssl_cert
        attribute :ssl_int
        attribute :ssl_key
        attribute :strategy
        attribute :vip

        def initialize(attributes={})
          super
        end

        def save
          requires :name
          requires :services
          requires :strategy
          options = {
            :name => name,
            :nodes => nodes,
            :region_id => region_id,
            :services => services,
            :session_persistence => session_persistence,
            :ssl_termination => ssl_termination,
            :ssl_cert => ssl_cert,
            :ssl_includes => ssl_includes,
            :ssl_int => ssl_int,
            :ssl_key => ssl_key,
            :strategy => strategy
          }.delete_if {|k,v| v.nil? || v == "" }
          data = service.create_balancer(options).body
          merge_attributes(data)
          true
        end

        def add_node(options)
          requires :identity
          data = service.add_balancer_node({:uniq_id => identity}.merge!(options)).body
          merge_attributes(data)
          true
        end

        def remove_node(options)
          requires :identity
          data = service.remove_balancer_node({:uniq_id => identity}.merge!(options)).body
          merge_attributes(data)
          true
        end

        def add_service(options)
          requires :identity
          data = service.add_balancer_service({:uniq_id => identity}.merge!(options)).body
          merge_attributes(data)
          true
        end

        def remove_service(options)
          requires :identity
          data = service.remove_balancer_service({:uniq_id => identity}.merge!(options)).body
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.delete_balancer(:uniq_id => identity).body
          true
        end

      end

    end
  end
end
