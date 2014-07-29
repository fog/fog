require 'fog/orchestration/models/resources'
require 'fog/rackspace/models/orchestration/resource'

module Fog
  module Orchestration
    class Rackspace
      # Resources for stack
      class Resources < Fog::Orchestration::Resources

        # Register stack resource model
        model Fog::Orchestration::Rackspace::Resource

        # Load all resources for stack
        #
        # @param load_stack [Fog::Orchestration::Rackspace::Stack]
        # @return [self]
        def all(load_stack=nil)
          self.stack = load_stack if load_stack
          if(self.stack)
            unless(self.stack.attributes['resources'])
              self.stack.attributes['resources'] = service.list_resources_stack(
                stack.stack_name, stack.id
              ).body['resources']
            end
            items = self.stack.attributes['resources']
          else
            items = []
          end
          load(items)
        end

        # Remove cached resources data
        #
        # @return [self]
        def reload
          if(self.stack)
            self.stack.attributes.delete('resources')
          end
          self
        end

      end
    end
  end
end
