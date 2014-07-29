module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return resource events for a stack
        #
        # @param stack_name [String] name of stack
        # @param stack_id [String] ID of stack
        #
        # @return [Excon::Response]
        #   * body [Hash]:
        #     * events [Array]:
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_stack_event_list_v1__tenant_id__stacks__stack_name___stack_id__events_Stack_Events.html
        def list_events_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'events'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock

        MOCK_EVENTS = [{"event_time"=>"2014-02-04T21:20:01Z", "id"=>"3000d1f9-6861-435f-abf7-02d58fd3703b", "links"=>[{"href"=>"http://hostname/v1/1234/stacks/mystack/56789/resources/mysql_server/events/3000d1f9-6861-435f-abf7-02d58fd3703b", "rel"=>"self"}, {"href"=>"http://hostname/v1/1234/stacks/mystack/56789/resources/mysql_server", "rel"=>"resource"}, {"href"=>"http://hostname/v1/1234/stacks/mystack/56789", "rel"=>"stack"}], "logical_resource_id"=>"mysql_server", "physical_resource_id"=>"0001", "resource_name"=>"mysql_server", "resource_status"=>"CREATE_COMPLETE", "resource_status_reason"=>"state changed"}, {"event_time"=>"2014-02-04T21:17:14Z", "id"=>"413b4334-7b69-4a59-bfd8-7ac6925d65c9", "links"=>[{"href"=>"http://hostname/v1/1234/stacks/mystack/56789/resources/mysql_server/events/413b4334-7b69-4a59-bfd8-7ac6925d65c9", "rel"=>"self"}, {"href"=>"http://hostname/v1/1234/stacks/mystack/56789/resources/mysql_server", "rel"=>"resource"}, {"href"=>"http://hostname/v1/1234/stacks/mystack/56789", "rel"=>"stack"}], "logical_resource_id"=>"mysql_server", "physical_resource_id"=>nil, "resource_name"=>"mysql_server", "resource_status"=>"CREATE_IN_PROGRESS", "resource_status_reason"=>"state changed"}]

        def list_events_stack(stack_name, stack_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {'events' => MOCK_EVENTS}
          response
        end
      end
    end
  end
end
