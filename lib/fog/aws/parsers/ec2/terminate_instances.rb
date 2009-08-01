module Fog
  module Parsers
    module AWS
      module EC2

        class TerminateInstances < Fog::Parsers::Base

          def reset
            @instance = { 'previousState' => {}, 'shutdownState' => {} }
            @response = { 'instancesSet' => [] }
          end

          def start_element(name, attrs = [])
            if name == 'previousState'
              @in_previous_state = true
            elsif name == 'shutdownState'
              @in_shutdown_state = true
            end
            @value = ''
          end

          def end_element(name)
            case name
            when 'instanceId'
              @instance[name] = @value
            when 'item'
              @response['instancesSet'] << @instance
              @instance = { 'previousState' => {}, 'shutdownState' => {} }
            when 'code'
              if @in_previous_state
                @instance['previousState'][name] = @value.to_i
              elsif @in_shutdown_state
                @instance['shutdownState'][name] = @value.to_i
              end
            when 'name'
              if @in_previous_state
                @instance['previousState'][name] = @value
              elsif @in_shutdown_state
                @instance['shutdownState'][name] = @value
              end
            when 'previousState'
              @in_previous_state = false
            when 'requestId'
              @response[name] = @value
            when 'shutdownState'
              @in_shutdown_state = false
            end
          end

        end

      end
    end
  end
end
