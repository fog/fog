require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class LoadBalancer < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :status

        attribute :policy
        attribute :nodes
        attribute :healthcheck
        attribute :listeners

        # Times
        attribute :created_at, :type => :time
        attribute :deleted_at, :type => :time

        # Links - to be replaced
        attribute :account
        attribute :server
        attribute :cloud_ip

        def ready?
          status == 'active'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
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
