require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module EC2

        class AllocateAddress < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'publicIp'
              @response[:public_ip] = @value
            end
          end

        end

        class Basic < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'requestId'
              @response[:request_id] = @value
            when 'return'
              if @value == 'true'
                @response[:return] = true
              else
                @response[:return] = false
              end
            end
          end

        end

        class CreateVolume < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'availabilityZone'
              @response[:availability_zone] = @value
            when 'createTime'
              @response[:create_time] = Time.parse(@value)
            when 'requestId'
              @response[:request_id] = @value
            when 'size'
              @response[:size] = @value.to_i
            when 'snapshotId'
              @response[:snapshot_id] = @value
            when 'status'
              @response[:status] = @value
            when 'volumeId'
              @response[:volume_id] = @value
            end
          end

        end

        class DescribeAddresses < Fog::Parsers::Base

          def reset
            @address = {}
            @response = { :address_set => [] }
          end

          def end_element(name)
            case name
            when 'instanceId'
              @address[:instance_id] = @value
            when 'item'
              @response[:address_set] << @address
              @address = []
            when 'publicIp'
              @address[:public_ip] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class DescribeImages < Fog::Parsers::Base

          def reset
            @image = {}
            @response = { :image_set => [] }
          end

          def end_element(name)
            case name
            when 'architecture'
              @image[:architecture] = @value
            when 'imageId'
              @image[:image_id] = @value
            when 'imageLocation'
              @image[:image_location] = @value
            when 'imageOwnerId'
              @image[:image_owner_id] = @value
            when 'imageState'
              @image[:image_state] = @value
            when 'imageType'
              @image[:image_type] = @value
            when 'isPublic'
              if @value == 'true'
                @image[:is_public] = true
              else
                @image[:is_public] = false
              end
            when 'item'
              @response[:image_set] << @image
              @image = {}
            when 'kernelId'
              @image[:kernel_id] = @value
            when 'ramdiskId'
              @image[:ramdisk_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class DescribeVolumes < Fog::Parsers::Base

          def reset
            @attachment = {}
            @in_attachment_set = false
            @response = { :volume_set => [] }
            @volume = { :attachment_set => [] }
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

          def start_element(name, attrs = [])
            if name == 'attachmentSet'
              @in_attachment_set = true
            end
            @value = ''
          end

        end

      end
    end
  end
end