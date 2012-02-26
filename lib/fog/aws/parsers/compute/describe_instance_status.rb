module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeInstanceStatus < Fog::Parsers::Base

          def new_instance
            @instance = { 'instanceState' => {}, 'systemStatus' => { 'details' => [] }, 'instanceStatus' => { 'details' => [] }, 'event' => {} }
          end

          def new_item
            @item = {}
          end

          def reset
            @instance_status = {}
            @response = { 'instanceStatusSet' => [] }
            @in_system_status = false
            @in_details = false
            @in_event = false
            new_instance
            new_item
          end

          def start_element(name, attrs=[])
            super
            case name
            when 'systemStatus'
              @in_system_status = true
            when 'instanceStatus'
              @in_instance_status = true
            when 'details'
              @in_details = true
            when 'event'
              @in_event = true
            end
          end

          def end_element(name)
            case name
            when 'name'
              if @in_details
                @item[name] = value
              else
                @instance['instanceState'][name] = value
              end
            when 'status'
              if @in_details
                @item[name] = value
              elsif @in_system_status
                @instance['systemStatus'][name] = value
              elsif @in_instance_status
                @instance['instanceStatus'][name] = value
              end
            when 'details'
              @in_details = false
            when 'item'
              if @in_system_status
                @instance['systemStatus']['details'] << @item
              elsif @in_instance_status
                @instance['instanceStatus']['details'] << @item
              else
                @response['instanceStatusSet'] << @instance
                new_instance
              end
              new_item
            when 'instanceStatus'
              @in_instance_status = false
            when 'systemStatus'
              @in_system_status = false
            when 'code'
              if @in_event
                @instance['event'][name] = value.strip
              else
                @instance['instanceState'][name] = value
              end
            when 'description'
              if @in_event
                @instance['event'][name] = value.strip
              end
            when 'notAfter', 'notBefore'
              if @in_event
                @instance['event'][name] = Time.parse(value)
              end
            when 'event'
              @in_event = false
            when 'instanceId', 'availabilityZone'
              @instance[name] = value
            when 'requestId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
