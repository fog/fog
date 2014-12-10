require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/alarm'

module Fog
  module Rackspace
    class Monitoring
      class Alarms < Fog::Collection
        attribute :entity
        attribute :marker

        model Fog::Rackspace::Monitoring::Alarm

        def all(options={})
          requires :entity
          data = service.list_alarms(entity.identity, options).body
          self.marker = data['metadata']['next_marker']

          load(data['values'])
        end

        def get(alarm_id)
          requires :entity
          data = service.get_alarm(entity.identity, alarm_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end

        def new(attributes = {})
          requires :entity
          super({ :entity => entity }.merge!(attributes))
        end

        def create(attributes = {})
          requires :entity
          super({ :entity => entity }.merge!(attributes))
        end
      end
    end
  end
end
