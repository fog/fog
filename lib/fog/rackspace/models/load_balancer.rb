require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancer
      class LoadBalancer < Fog::Model

        identity :id

        attribute :cluster
        attribute :connection_logging
        attribute :port
        attribute :protocol
        attribute :algorithm
        attribute :virtual_ips
        attribute :nodes
        attribute :created
        attribute :updated
        attribute :name
        attribute :state,       :aliases => 'status'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id
          connection.delete_load_balancer(id)
          true
        end

        def ready?
          self.state == 'ACTIVE'
        end

        def save
          if identity
            update
          else
            create
          end
          true
        end

        private
        def create
          requires :name, :protocol, :port, :virtual_ips, :nodes
          data = connection.create_load_balancer(name, protocol, port, virtual_ips, nodes)
          merge_attributes(data.body['loadBalancer'])
        end

        def update
          requires :name, :protool, :port, :algorithm
          options = {
            'name' => name,
            'algorithm' => algorithm,
            'protocol' => protocol,
            'port' => port}
          connection.update_load_balancer(identity, options)
        end
      end
    end
  end
end
