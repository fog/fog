module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeVolumes < Fog::Parsers::Base

          def reset
            @attachment = {}
            @in_attachment_set = false
            @response = { :volume_set => [] }
            @volume = { :attachment_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'attachmentSet'
              @in_attachment_set = true
            end
            @value = ''
          end

          def end_element(name)
            if @in_attachment_set
              case name
              when 'attachmentSet'
                @in_attachment_set = false
              when 'attachTime'
                @attachment[:attach_time] = Time.parse(@value)
              when 'device'
                @attachment[:device] = @value
              when 'instanceId'
                @attachment[:instance_id] = @value
              when 'item'
                @volume[:attachment_set] << @attachment
                @attachment = {}
              when 'status'
                @attachment[:status] = @value
              when 'volumeId'
                @attachment[:volume_id] = @value
              end
            else
              case name
              when 'availabilityZone'
                @volume[:availability_zone] = @value
              when 'createTime'
                @volume[:create_time] = Time.parse(@value)
              when 'item'
                @response[:volume_set] << @volume
                @volume = { :attachment_set => [] }
              when 'requestId'
                @response[:request_id] = @value
              when 'size'
                @volume[:size] = @value.to_i
              when 'snapshotId'
                @volume[:snapshot_id] = @value
              when 'status'
                @volume[:status] = @value
              when 'volumeId'
                @volume[:volume_id] = @value
              end
            end
          end

        end

      end
    end
  end
end
