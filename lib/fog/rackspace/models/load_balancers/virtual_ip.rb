require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancers
      class VirtualIp < Fog::Model
        identity :id

        attribute :address
        attribute :type
        attribute :ip_version, :aliases => 'ipVersion'

        def destroy
          requires :identity, :load_balancer
          service.delete_virtual_ip(load_balancer.identity, identity)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :load_balancer, :type
          data = service.create_virtual_ip(load_balancer.id, type)
          merge_attributes(data.body)
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
