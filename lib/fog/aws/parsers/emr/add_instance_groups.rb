module Fog
  module Parsers
    module AWS
      module EMR

        class AddInstanceGroups < Fog::Parsers::Base

          def start_element(name, attrs = [])
            super
            case name
            when 'InstanceGroupIds'
              @in_instance_group_ids = true
              @instance_groups_ids = []
            end
          end

          def end_element(name)
            case name
            when 'JobFlowId'
              @response[name] = value
            when 'InstanceGroupIds'
              @in_instance_group_ids = false
              @response['InstanceGroupIds'] = @instance_group_ids
            when 'InstanceGroupId'
              @instance_group_ids << value
            end
          end
        end
      end
    end
  end
end
