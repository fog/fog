require 'fog/core/collection'
require 'fog/openstack/models/network/lb_health_monitor'

module Fog
  module Network
    class OpenStack
      class LbHealthMonitors < Fog::Collection

        attribute :filters

        model Fog::Network::OpenStack::LbHealthMonitor

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_lb_health_monitors(filters).body['health_monitors'])
        end

        def get(health_monitor_id)
          if health_monitor = service.get_lb_health_monitor(health_monitor_id).body['health_monitor']
            new(health_monitor)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end