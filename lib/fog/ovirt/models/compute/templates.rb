require 'fog/core/collection'
require 'fog/ovirt/models/compute/template'
require 'fog/ovirt/models/compute/helpers/collection_helper'

module Fog
  module Compute
    class Ovirt

      class Templates < Fog::Collection

        include Fog::Compute::Ovirt::Helpers::CollectionHelper
        model Fog::Compute::Ovirt::Template

        def all(filters = {})
          attrs = connection.client.templates(filters).map { |template| ovirt_attrs(template) }
          load attrs
        end

        def get(id)
          new ovirt_attrs(connection.client.template(id))
        end

      end
    end
  end
end
