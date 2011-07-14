require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancer
      class LoadBalancer < Fog::Model

        identity :id

        attribute :cluster
        attribute :connection_logging,  :aliases => 'connectionLogging'
        attribute :port
        attribute :protocol
        attribute :algorithm
        attribute :virtual_ips,         :aliases => 'virtualIps'
        attribute :created
        attribute :updated
        attribute :name
        attribute :state,               :aliases => 'status'

        def nodes
          @nodes
        end

        def nodes=(new_nodes)
          @nodes = Fog::Rackspace::LoadBalancer::Nodes.new({
            :connection => connection,
            :load_balancer => self})
          @nodes.load(new_nodes)
        end

        def destroy
          requires :identity
          connection.delete_load_balancer(identity)
          true
        end

        def ready?
          state == 'ACTIVE'
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
          data = connection.create_load_balancer(name, protocol, port, virtual_ips, nodes.to_object)
          merge_attributes(data.body['loadBalancer'])
        end

        def update
          requires :name, :protocol, :port, :algorithm
          options = {
            :name => name,
            :algorithm => algorithm,
            :protocol => protocol,
            :port => port}
          connection.update_load_balancer(identity, options)

          #TODO - Should this bubble down to nodes? Without tracking changes this would be very inefficient.
          # For now, individual nodes will have to be saved individually after saving an LB
        end
      end
    end
  end
end
