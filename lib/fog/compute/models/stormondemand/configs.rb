require 'fog/core/collection'
require 'fog/compute/models/stormondemand/config'

module Fog
  module StormOnDemand
    class Compute

      class Configs < Fog::Collection

        model Fog::StormOnDemand::Compute::Config

        def all
          data = connection.list_configs.body['configs']
          load(data)
        end


      end

    end
  end
end
