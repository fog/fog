require 'fog/core/collection'

module Fog
  module Orchestration
    class OpenStack
      class ResourceSchemas < Fog::Collection

        def get(resource_type)
          service.show_resource_schema(resource_type).body
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end
    end
  end
end
