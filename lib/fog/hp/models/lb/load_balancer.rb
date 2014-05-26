require 'fog/core/model'

module Fog
  module HP
    class LB
      class LoadBalancer < Fog::Model
        identity  :id

        attribute :name
        attribute :protocol
        attribute :port
        attribute :algorithm
        attribute :status
        attribute :status_description, :aliases => 'statusDescription'
        attribute :nodes
        attribute :virtual_ips, :aliases => 'virtualIps'
        attribute :node_count,  :aliases => 'nodeCount'
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at , :aliases => 'updated'

        def destroy
          requires :id
          service.delete_load_balancer(id)
          true
        end

        def ready?
          self.status == 'ACTIVE'
        end

        def save
          identity ? update : create
        end

        def nodes
          @nodes ||= begin
            Fog::HP::LB::Nodes.new({
              :service  => service,
              :load_balancer   => self
            })
          end
        end

        def nodes=(new_nodes=[])
          nodes.load(new_nodes)
        end

        private

        def create
          requires :name, :nodes

          options = {}
          options['virtualIps'] = virtual_ips if virtual_ips
          options['port']       = port if port
          options['protocol']   = protocol if protocol
          options['algorithm']  = algorithm if algorithm
          merge_attributes(service.create_load_balancer(name, nodes_to_hash, options).body)
          true
        end

        def update
          requires :id

          options = {}
          options['name']       = name if name
          options['algorithm']  = algorithm if algorithm
          service.update_load_balancer(id, options).body
          true
        end

        def nodes_to_hash
          if nodes
            nodes.map do |node|
              { 'address' => node.address, 'port' => node.port, 'condition' => node.condition }
            end
          end
        end
      end
    end
  end
end
