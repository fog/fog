require 'fog/openstack/models/orchestration/event'

module Fog
  module Orchestration
    class OpenStack
      class Events < Fog::Collection
        model Fog::Orchestration::OpenStack::Event

        def all(obj, options={})
          data = if obj.is_a?(Stack)
            service.list_stack_events(obj, options).body['events']
          else
            service.list_resource_events(obj.stack, obj, options).body['events']
          end

          load data
        end

        def get(stack, resource, event_id)
          data = service.show_event_details(stack, resource, event_id).body['event']
          new(data)
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
