require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancers
      class LoadBalancer < Fog::Model

        #States
        ACTIVE = 'ACTIVE'
        ERROR = 'ERROR'
        PENDING_UPDATE = 'PENDING_UPDATE'
        PENDING_DELTE = 'PENDING_DELETE'
        SUSPENDED = 'SUSPENDED'
        DELETED = 'DELETED'
        BUILD = 'BUILD'

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

        def access_rules
          @access_rules ||= begin
            Fog::Rackspace::LoadBalancers::AccessRules.new({
              :connection => connection,
              :load_balancer => self})
          end
        end

        def access_rules=(new_access_rules=[])
          access_rules.load(new_access_rules)
        end

        def nodes
          @nodes ||= begin
            Fog::Rackspace::LoadBalancers::Nodes.new({
              :connection => connection,
              :load_balancer => self})
          end
        end

        def nodes=(new_nodes=[])
          nodes.load(new_nodes)
        end

        def virtual_ips
          @virtual_ips ||= begin
            Fog::Rackspace::LoadBalancers::VirtualIps.new({
              :connection => connection,
              :load_balancer => self})
          end
        end

        def virtual_ips=(new_virtual_ips=[])
          virtual_ips.load(new_virtual_ips)
        end

        def enable_connection_logging
          requires :identity
          connection.set_connection_logging identity, true
          attributes[:connection_logging] = true
        end

        def disable_connection_logging
          requires :identity
          connection.set_connection_logging identity, false
          attributes[:connection_logging] = false
        end

        def health_monitor
          requires :identity
          monitor = connection.get_monitor(identity).body['healthMonitor']
          monitor.count == 0 ? nil : monitor
        end

        def enable_health_monitor(type, delay, timeout, attempsBeforeDeactivation, options = {})
          requires :identity
          connection.set_monitor(identity, type, delay, timeout, attempsBeforeDeactivation, options)
          true
        end

        def disable_health_monitor
          requires :identity
          connection.remove_monitor(identity)
          true
        end

        def connection_throttling
          requires :identity
          throttle = connection.get_connection_throttling(identity).body['connectionThrottle']
          throttle.count == 0 ? nil : throttle
        end

        def enable_connection_throttling(max_connections, min_connections, max_connection_rate, rate_interval)
          requires :identity
          connection.set_connection_throttling(identity, max_connections, min_connections, max_connection_rate, rate_interval)
          true
        end

        def disable_connection_throttling
          requires :identity
          connection.remove_connection_throttling(identity)
          true
        end

        def session_persistence
          requires :identity
          persistence = connection.get_session_persistence(identity).body['sessionPersistence']
          persistence.count == 0 ? nil : persistence
        end

        def enable_session_persistence(type)
          requires :identity
          connection.set_session_persistence(identity, type)
          true
        end

        def disable_session_persistence
          requires :identity
          connection.remove_session_persistence(identity)
          true
        end

        def destroy
          requires :identity
          connection.delete_load_balancer(identity)
          true
        end

        def ready?
          state == ACTIVE
        end

        def save
          if identity
            update
          else
            create
          end
          true
        end

        def usage(options = {})
          requires :identity
          connection.get_load_balancer_usage(identity, options).body
        end

        def error_page
          requires :identity
          connection.get_error_page(identity).body['errorpage']['content']
        end

        def error_page=(content)
          requires :identity
          connection.set_error_page identity, content
        end

        def reset_error_page
          requires :identity
          connection.remove_error_page identity
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
                                              when true,'true'
                                                true
                                              when false,'false'
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
