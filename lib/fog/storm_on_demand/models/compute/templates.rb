require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/template'

module Fog
  module Compute
    class StormOnDemand

      class Templates < Fog::Collection

        model Fog::Compute::StormOnDemand::Template

        def all
          data = service.list_templates(:page_size => 500).body['items']
          load(data)
        end

      end

    end
  end
end
