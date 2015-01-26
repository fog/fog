require 'fog/core/collection'
require 'fog/google/models/dns/project'

module Fog
  module DNS
    class Google
      class Projects < Fog::Collection
        model Fog::DNS::Google::Project

        ##
        # Fetches the representation of an existing Project
        #
        # @param [String] identity Project identity
        # @return [Fog::DNS::Google::Project] Project resource
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
