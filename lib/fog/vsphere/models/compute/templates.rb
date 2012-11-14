require 'fog/core/collection'
require 'fog/vsphere/models/compute/template'

module Fog
  module Compute
    class Vsphere

      class Templates < Fog::Collection

        model Fog::Compute::Vsphere::Template

        def all(filters = {})
          load connection.list_templates(filters)
        end

        def get(id)
          new connection.get_template(id)
        end

      end
    end
  end
end
