require 'fog/openstack/models/collection'
require 'fog/openstack/models/identity_v3/project'

module Fog
  module Identity
    class OpenStack
      class V3
        class Projects < Fog::OpenStack::Collection
          model Fog::Identity::OpenStack::V3::Project

          def all(options = {})
            load_response(service.list_projects(options), 'projects')
          end

          def auth_projects(options = {})
            load(service.auth_projects(options).body['projects'])
          end

          def find_by_id(id, options=[]) # options can include :subtree_as_ids, :subtree_as_list, :parents_as_ids, :parents_as_list
            if options.is_a? Symbol # Deal with a single option being passed on its own
              options = [options]
            end
            cached_project = self.find { |project| project.id == id } if options.empty?
            return cached_project if cached_project
            project_hash = service.get_project(id, options).body['project']
            Fog::Identity::OpenStack::V3::Project.new(
                project_hash.merge(:service => service))
          end

        end
      end
    end
  end
end
