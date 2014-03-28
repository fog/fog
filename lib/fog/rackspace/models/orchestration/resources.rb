require 'fog/orchestration/models/resources'
require 'fog/rackspace/models/orchestration/resource'

module Fog
  module Orchestration
    class Rackspace
      class Resources < Fog::Orchestration::Resources

        model Fog::Orchestration::Rackspace::Resource

        def all(stack)
          load(service.list_resources_stack(stack.stack_name, stack.id).body['resources'])
        end

      end
    end
  end
end
