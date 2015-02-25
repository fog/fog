require 'fog/openstack/models/orchestration/resource'

module Fog
  module Orchestration
    class OpenStack
      class Resources < Fog::Collection
        model Fog::Orchestration::OpenStack::Resource

        def types
          service.list_resource_types.body['resource_types'].sort
        end

        def all(stack, options={})
          data = service.list_resources(stack, options).body['resources']
          load(data)
        end

        def get(resource_name, stack=nil)
          stack = self.first.stack if stack.nil?
          data  = service.show_resource_data(stack.stack_name, stack.id, resource_name).body['resource']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

        def metadata(stack_name, stack_id, resource_name)
          service.show_resource_metadata(stack_name, stack_id, resource_name).body['resource']
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end
    end
  end
end
