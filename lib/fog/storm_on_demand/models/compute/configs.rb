require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/config'

module Fog
  module Compute
    class StormOnDemand

      class Configs < Fog::Collection

        model Fog::Compute::StormOnDemand::Config

        def all
          data = service.list_configs(:category => 'all', :available => 1, :page_size => 500).body['items']
          load(data)
        end

        def get(category)
          data = service.list_configs(:category => category, :available => 1, :page_size => 500).body['items']
          load(data)
        end

      end

    end
  end
end
