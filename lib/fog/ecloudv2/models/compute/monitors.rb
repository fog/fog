require 'fog/ecloudv2/models/compute/monitor'

module Fog
  module Compute
    class Ecloudv2
      class Monitors < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Monitor

        def all
          data = connection.get_monitors(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_monitor(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def from_data(data)
          new(data)
        end
      end
    end
  end
end
