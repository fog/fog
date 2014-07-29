module Fog
  module Orchestration
    class Rackspace
      class Real

        # Return resources for a stack
        #
        # @param stack_name [String] name of stack
        # @param stack_id [String] ID of stack
        #
        # @see http://docs.rackspace.com/orchestration/api/v1/orchestration-devguide/content/GET_resource_list_v1__tenant_id__stacks__stack_name___stack_id__resources_Stack_Resources.html
        def list_resources_stack(stack_name, stack_id)
          request(
            :expects  => 200,
            :path => ['stacks', stack_name, stack_id, 'resources'].join('/'),
            :method => 'GET'
          )
        end

      end

      class Mock

        MOCK_RESOURCES = [{"resource_name"=>"MySqlCloudDatabaseServer", "links"=>[{"href"=>"https://dfw.orchestration.rackspacecloud.com/v1/tenant_id/stacks/trove2/87xxxx1-9xx9-4xxe-bxxf-a7xxxxxd99068/resources/MySqlCloudDatabaseServer", "rel"=>"self"}, {"href"=>"http:s//dfw.orchestration.rackspacecloud.com/v1/tenant_id/stacks/trove2/87xxxx1-9xx9-4xxe-bxxf-a7xxxxx068", "rel"=>"stack"}], "logical_resource_id"=>"MySqlCloudDatabaseServer", "resource_status_reason"=>"state changed", "updated_time"=>"2014-02-05T19:20:31Z", "required_by"=>[], "resource_status"=>"CREATE_COMPLETE", "physical_resource_id"=>"984xxxxxe0-c7x8-4x6e-be15-3f0xxxxx711", "resource_type"=>"OS::Trove::Instance"}]

        def list_resources_stack(stack_name, stack_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {'resources' => MOCK_RESOURCES}
          response
        end
      end
    end
  end
end
