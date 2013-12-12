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

      end
    end
  end
end
