require 'fog/openstack/models/orchestration/event'

module Fog
  module Orchestration
    class OpenStack
      class Events < Fog::Collection
        model Fog::Orchestration::OpenStack::Event

        def all(options = {}, options_deprecated = {})
          data = if options.is_a?(Stack)
                   service.list_stack_events(options, options_deprecated).body['events']
                 elsif options.is_a?(Hash)
                   service.list_events(options).body['events']
                 else
                   service.list_resource_events(options.stack, options, options_deprecated).body['events']
                 end

          load data
        end

        alias_method :summary, :all

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
