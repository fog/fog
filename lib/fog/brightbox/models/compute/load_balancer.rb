require 'fog/core/model'

module Fog
  module Brightbox
    class Compute

      class LoadBalancer < Fog::Model

        identity :id

        attribute :url
        attribute :name
        attribute :status
        attribute :resource_type

        attribute :nodes
        attribute :policy
        attribute :healthcheck
        attribute :listeners
        attribute :account

        def ready?
          status == 'active'
        end

        def save
          requires :nodes, :listeners, :healthcheck
          options = {
            :nodes => nodes,
            :listeners => listeners,
            :healthcheck => healthcheck,
            :policy => policy,
            :name => name
          }.delete_if {|k,v| v.nil? || v == "" }
          data = connection.create_load_balancer(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          connection.destroy_load_balancer(identity)
          true
        end

      end

    end
  end
end
