require 'fog/core/collection'
require 'fog/compute/models/stormondemand/stat'

module Fog
  module Stormondemand
    class Compute

      class Stats < Fog::Collection
        model Fog::Stormondemand::Compute::Stat

        def get(options)
          data = connection.get_stats(options).body
          load(data)
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
