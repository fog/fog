require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancers
      class AccessRule < Fog::Model

        identity :id

        attribute :address
        attribute :type

        def destroy
          requires :identity, :load_balancer
          connection.delete_access_rule(load_balancer.identity, identity)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :load_balancer, :address, :type
          connection.create_access_rule(load_balancer.id, address, type)

          #Unfortunately, access rules creation doesn't return an ID, we require a subsequent list call and comparison
          data = connection.list_access_rules(load_balancer.id).body['accessList'].select do |ar|
            ar['address'] == address && ar['type'] == type
          end.first
          merge_attributes(data)
          true
        end

        private
        def load_balancer
          collection.load_balancer
        end
      end
    end
  end
end
