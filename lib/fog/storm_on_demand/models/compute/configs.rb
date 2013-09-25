require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/config'

module Fog
  module Compute
    class StormOnDemand

      class Configs < Fog::Collection

        model Fog::Compute::StormOnDemand::Config

        def all(options={})
          data = service.list_configs(options).body['items']
          load(data)
        end

        def get(config_id)
          data = service.get_config_details(:id => config_id).body
          new(data)
        end

      end

    end
  end
end
