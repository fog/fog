module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeVolumeStatus < Fog::Parsers::Base

          def new_volume
            @volume = { 'volumeStatus' => { 'details' => [] }, 'eventSet' => {}, 'actionSet' => {} }
          end

          def reset
            @volume_status = {}
            @response = { 'volumeStatusSet' => [] }
            @inside = nil
          end

          def start_element(name, attrs=[])
            super
            case name
            when 'item'
              new_volume if @inside.nil?
            when 'volumeStatus'
              @inside = :volume_status
            when 'details'
              @inside = :details
            when 'eventSet'
              @inside = :event
            when 'actionSet'
              @inside = :action
            end
          end

          def end_element(name)
            case name
            #Simple closers
            when 'details'
              @inside = nil
            when 'volumeStatus'
              @inside = nil
            when 'eventSet'
              @inside = nil
            when 'actionSet'
              @inside = nil
            when 'item'
              @response['volumeStatusSet'] << @volume if @inside.nil?
            #Top level
            when 'nextToken', 'requestId'
              @response[name] = value
            # Volume Stuff
            when 'volumeId', 'availabilityZone'
              @volume[name] = value
            #The mess...
            when 'name', 'status'
              case @inside
              when :details
                @volume['volumeStatus']['details'] << {name => value }
              when :volume_status
                @volume['volumeStatus'][name] = value
              end
            when 'code', 'eventId', 'eventType', 'description'
              @volume["#{@inside}Set"][name] = value.strip
            when 'notAfter', 'notBefore'
              @volume["#{@inside}Set"][name] = Time.parse(value)
            end
          end
        end
      end
    end
  end
end
