require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/entity'
require 'fog/rackspace/models/monitoring/check'

module Fog
  module Rackspace
    class Monitoring
      class Entities < Fog::Collection
        model Fog::Rackspace::Monitoring::Entity

        attribute :marker

        def all(options={})
          data = service.list_entities(options).body
          self.marker = data['metadata']['next_marker']

          load(data['values'])
        end

        def get(entity_id)
          data = service.get_entity(entity_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end

        def overview(options={})
          body = service.list_overview(options).body
          self.marker = body['metadata']['next_marker']

          load_all(body['values'])
        end

        def load_all(objects)
          clear
          for object in objects
            en = new(object['entity'])
            self << en
            en.checks.load(object['checks'])
            en.alarms.load(object['alarms'])
          end
          self
        end
      end
    end
  end
end
