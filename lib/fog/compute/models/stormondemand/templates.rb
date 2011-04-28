require 'fog/core/collection'
require 'fog/compute/models/stormondemand/template'

module Fog
  module Stormondemand
    class Compute

      class Templates < Fog::Collection

        model Fog::Stormondemand::Compute::Template

        def all
          data = connection.list_templates.body['templates']
          load(data)
        end

      end

    end
  end
end
