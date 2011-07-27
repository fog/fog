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
        attribute :nodes

        def initialize(attributes)
          #HACK - Since we are hacking how sub-collections work, we have to make sure the connection is valid first.
          @connection = attributes[:connection]
          super
        end

        def nodes
          @nodes ||= begin
            Fog::Rackspace::LoadBalancer::Nodes.new({
              :connection => connection,
              :load_balancer => self})
          end
        end

        def nodes=(new_nodes=[])
          nodes.load(new_nodes)
        end

        def virtual_ips
          @virtual_ips ||= begin
            Fog::Rackspace::LoadBalancer::VirtualIps.new({
              :connection => connection,
              :load_balancer => self})
          end
        end

        def connection_logging
          attributes[:connection_logging]
        end

        def virtual_ips=(new_virtual_ips=[])
          virtual_ips.load(new_virtual_ips)
        end

        def enable_connection_logging
          connection.set_connection_logging identity, true
          attributes[:connection_logging] = true
        end

        def disable_connection_logging
          connection.set_connection_logging identity, false
          attributes[:connection_logging] = false
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
          data = connection.create_load_balancer(name, protocol, port, virtual_ips_hash, nodes_hash)
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

        def virtual_ips_hash
          virtual_ips.collect do |virtual_ip|
            { :type => virtual_ip.type }
          end

        end

        def nodes_hash
          nodes.collect do |node|
            { :address => node.address, :port => node.port, :condition => node.condition, :weight => node.weight }
          end
        end

        def connection_logging=(new_value)
          if !new_value.nil? and new_value.is_a?(Hash)
            attributes[:connection_logging] = case new_value['enabled']
                                              when 'true'
                                                true
                                              when 'false'
                                                false
                                              end
          else
            attributes[:connection_logging] = new_value
          end
        end

      end
    end
  end
end
