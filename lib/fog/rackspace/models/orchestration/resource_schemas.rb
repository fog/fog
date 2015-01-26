
module Fog
  module Rackspace
    class Orchestration
      class ResourceSchemas < Fog::Collection

        def get(resource_type)
          service.show_resource_schema(resource_type).body
        rescue Fog::Rackspace::Orchestration::NotFound
          nil
        end

      end
    end
  end
end
