module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeVolumes < Fog::Parsers::Base

          def reset
            @attachment = {}
            @in_attachment_set = false
            @response = { 'volumeSet' => [] }
            @volume = { 'attachmentSet' => [] }
          end

          def start_element(name, attrs = [])
            super
            if name == 'attachmentSet'
              @in_attachment_set = true
            end
          end

          def end_element(name)
            if @in_attachment_set
              case name
              when 'attachmentSet'
                @in_attachment_set = false
              when 'attachTime'
                @attachment[name] = Time.parse(@value)
              when 'device', 'instanceId', 'status', 'volumeId'
                @attachment[name] = @value
              when 'item'
                @volume['attachmentSet'] << @attachment
                @attachment = {}
              end
            else
              case name
              when 'availabilityZone', 'snapshotId', 'status', 'volumeId'
                @volume[name] = @value
              when 'createTime'
                @volume[name] = Time.parse(@value)
              when 'item'
                @response['volumeSet'] << @volume
                @volume = { 'attachmentSet' => [] }
              when 'requestId'
                @response[name] = @value
              when 'size'
                @volume[name] = @value.to_i
              end
            end
          end

        end

      end
    end
  end
end
