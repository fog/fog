require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/template'

module Fog
  module Compute
    class StormOnDemand
      class Templates < Fog::Collection
        model Fog::Compute::StormOnDemand::Template

        def all(options={})
          data = service.list_templates(options).body['items']
          load(data)
        end

        def get(template_id)
          tpl = service.get_template_details(:id => template_id).body
          new(tpl)
        end
      end
    end
  end
end
