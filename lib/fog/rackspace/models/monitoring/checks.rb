require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/check'

module Fog
  module Rackspace
    class Monitoring
      class Checks < Fog::Collection
        attribute :entity
        attribute :marker

        model Fog::Rackspace::Monitoring::Check

        def all(options={})
          requires :entity
          data = service.list_checks(entity.identity, options).body
          self.marker = data['metadata']['next_marker']

          load(data['values'])
        end

        def get(check_id)
          requires :entity
          data = service.get_check(entity.identity, check_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end

        def new(attributes = {})
          requires :entity unless attributes[:entity]
          super({ :entity => entity }.merge!(attributes))
        end

        def create(attributes = {})
          requires :entity unless attributes[:entity]
          super({ :entity => entity }.merge!(attributes))
        end
      end
    end
  end
end
