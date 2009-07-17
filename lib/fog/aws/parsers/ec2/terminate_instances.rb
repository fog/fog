module Fog
  module Parsers
    module AWS
      module EC2

        class TerminateInstances < Fog::Parsers::Base

          def reset
            @instance = { :previous_state => {}, :shutdown_state => {} }
            @response = { :instance_set => [] }
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
            when 'item'
              @response[:instance_set] << @instance
              @instance = { :previous_state => {}, :shutdown_state => {} }
            when 'code'
              if @in_previous_state
                @instance[:previous_state][:code] = @value
              elsif @in_shutdown_state
                @instance[:shutdown_state][:code] = @value
              end
            when 'name'
              if @in_previous_state
                @instance[:previous_state][:name] = @value
              elsif @in_shutdown_state
                @instance[:shutdown_state][:name] = @value
              end
            when 'previousState'
              @in_previous_state = false
            when 'requestId'
              @response[:request_id] = @value
            when 'shutdownState'
              @in_shutdown_state = false
            end
          end

        end

      end
    end
  end
end
