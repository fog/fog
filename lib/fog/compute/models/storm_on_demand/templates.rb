require 'fog/core/collection'
require 'fog/compute/models/storm_on_demand/template'

module Fog
  module StormOnDemand
    class Compute

      class Templates < Fog::Collection

        model Fog::StormOnDemand::Compute::Template

        def all
          data = connection.list_templates.body['templates']
          load(data)
        end

      end

    end
  end
end
