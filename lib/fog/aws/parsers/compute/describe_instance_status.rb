module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeInstanceStatus < Fog::Parsers::Base

          def new_instance
            @instance = { 'eventsSet' => [], 'instanceState' => {} }
          end

          def new_event
            @event = {}
          end

          def reset
            @instance_status = {}
            @response = { 'instanceStatusSet' => [] }
            @in_events_set = false
            new_event
            new_instance
          end

          def start_element(name, attrs=[])
            super
            case name
            when 'eventsSet'
              @in_events_set = true
            end
          end


          def end_element(name)
            if @in_events_set
              case name
              when 'code', 'description'
                @event[name] = value
              when 'notAfter', 'notBefore'
                @event[name] = Time.parse(value)
              when 'item'
                @instance['eventsSet'] << @event
                new_event
              when 'eventsSet'
                @in_events_set = false
              end
            else
              case name
              when 'instanceId', 'availabilityZone'
                @instance[name] = value
              when 'name', 'code'
                @instance['instanceState'][name] = value
              when 'item'
                @response['instanceStatusSet'] << @instance
                new_instance
              when 'requestId'
                @response[name] = value

              end
            end
          end
        end
      end
    end
  end
end
