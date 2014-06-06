require 'fog/core/collection'
require 'fog/google/models/compute/project'

module Fog
  module Compute
    class Google
      class Projects < Fog::Collection
        model Fog::Compute::Google::Project

        def get(identity)
          if project = service.get_project(identity).body
            new(project)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
