require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/entity'
require 'fog/rackspace/models/monitoring/check'

module Fog
  module Rackspace
    class Monitoring
      class Entities < Fog::Collection

        model Fog::Rackspace::Monitoring::Entity

        def all
          data = service.list_entities.body['values']
          load(data)
        end

        def get(entity_id)
          data = service.get_entity(entity_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end

        def overview
          entities = []
          opts = {}
          begin
            new_entities = service.list_overview(opts)
            entities.concat(new_entities.body['values'])
            opts = {:marker => new_entities.body['metadata']['next_marker']}
          end while(!opts[:marker].nil?)
          loadAll(entities)
        end

        def loadAll(objects)
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
