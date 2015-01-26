require 'fog/core/collection'
require 'fog/ovirt/models/compute/template'

module Fog
  module Compute
    class Ovirt
      class Templates < Fog::Collection
        model Fog::Compute::Ovirt::Template

        def all(filters = {})
          load service.list_templates(filters)
        end

        def get(id)
          new service.get_template(id)
        end
      end
    end
  end
end
