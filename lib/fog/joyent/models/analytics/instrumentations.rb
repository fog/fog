require 'fog/joyent/models/analytics/instrumentation'

module Fog
  module Joyent
    class Analytics
      class Instrumentations < Fog::Collection
        model Fog::Joyent::Analytics::Instrumentation

        def all
          data = service.list_instrumentations.body
          load(data)
        end

        def get(id)
          data = service.get_instrumentation(id).body
          new(data)
        rescue Fog::Compute::Joyent::Errors::NotFound
          nil
        end
      end
    end
  end
end
