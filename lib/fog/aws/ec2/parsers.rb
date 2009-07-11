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

        class CreateKeyPair < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'keyFingerprint'
              @response[:key_fingerprint] = @value
            when 'keyMaterial'
              @response[:key_material] = @value
            when 'keyName'
              @response[:key_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class CreateSnapshot < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'progress'
              @response[:progress] = @value
            when 'snapshotId'
              @response[:snapshot_id] = @value
            when 'startTime'
              @response[:start_time] = Time.parse(@value)
            when 'status'
              @response[:status] = @value
            when 'volumeId'
              @response[:volume_id] = @value
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
            @image = { :product_codes => [] }
            @response = { :image_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'productCodes'
              @in_product_codes = true
            end
            @value = ''
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
              unless @in_product_codes
                @response[:image_set] << @image
                @image = { :product_codes => [] }
              end
            when 'kernelId'
              @image[:kernel_id] = @value
            when 'platform'
              @image[:platform] = @value
            when 'productCode'
              @image[:product_codes] << @value
            when 'productCodes'
              @in_product_codes = false
            when 'ramdiskId'
              @image[:ramdisk_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class DescribeInstances < Fog::Parsers::Base

          def reset
            @instance = { :instance_state => {}, :placement => [], :product_code_set => [] }
            @reservation = { :group_set => [], :instances_set => [] }
            @response = { :reservation_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'groupSet'
              @in_subset = true
            end
            if name == 'productCodeSet'
              @in_subset = true
            end
            if name == 'instanceSet'
              @in_instances_set = true
            end
            @value = ''
          end

          def end_element
            case name
            when 'amiLaunchIndex'
              @instance[:ami_launch_index] = @value
            when 'availabilityZone'
              @instance[:placement] << @value
            when 'code'
              @instance[:instance_state][:code] = @value
            when 'dnsNmae'
              @instance[:dns_name] = @value
            when 'groupId'
              @reservation[:group_set] << @value
            when 'groupSet'
              @in_subset = false
            when 'imageId'
              @instance[:image_id] = @value
            when 'instanceId'
              @instance[:instance_id] = @value
            when 'instancesSet'
              @in_instances_set = false
            when 'instanceType'
              @instance[:instance_type] = @value
            when 'item'
              if @in_instances_set
                @reservation[:instances_set] << @instance
                @instance = { :instance_state => {}, :placement => [], :product_code_set => [] }
              elsif !@in_subset
                @response[:reservation_set] << @reservation
                @reservation = { :group_set => [], :instance_set => [] }
              end
            when 'kernelId'
              @instance[:kernel_id] = @value
            when 'keyName'
              @instance[:key_name] = @value
            when 'launchTime'
              @instance[:launch_time] = Time.parse(@value)
            when 'name'
              @instance[:instance_state][:name] = @value
            when 'ownerId'
              @reservation[:owner_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'reservationId'
              @reservation[:reservation_id] = @value
            when 'privateDnsName'
              @instance[:private_dns_name] = @value
            when 'productCode'
              @instance[:product_code_set] << @value
            when 'productCodeSet'
              @in_subset = false
            when 'ramdiskId'
              @instance[:ramdisk_id] = @value
            end
          end

        end

        class DescribeKeyPairs < Fog::Parsers::Base

          def reset
            @key = {}
            @response = { :key_set => [] }
          end

          def end_element(name)
            case name
            when 'item'
              @response[:key_set] << @key
              @key = {}
            when 'keyFingerprint'
              @key[:key_fingerprint] = @value
            when 'keyName'
              @key[:key_name] = @value
            when 'requestId'
              @response[:request_id] = @value
            end
          end

        end

        class DescribeSecurityGroups < Fog::Parsers::Base

          def reset
            @group = {}
            @ip_permission = { :groups => [], :ip_ranges => []}
            @ip_range = {}
            @in_ip_permissions = false
            @item = { :ip_permissions => [] }
            @response = { :security_group_info => [] }
          end

          def start_element(name, attrs = [])
            if name == 'ipPermissions'
              @in_ip_permissions = true
            end
            if name == 'groups'
              @in_groups = true
            end
            if name == 'ip_ranges'
              @in_ip_ranges = true
            end
            @value = ''
          end

          def end_element(name)
            if !@in_ip_permissions
              case name
              when 'groupName'
                @item[:group_name] = @value
              when 'groupDescription'
                @item[:group_description] = @value
              when 'item'
                @response[:security_group_info] << @item
                @item = { :ip_permissions => [] }
              when 'ownerId'
                @item[:owner_id] = @value
              end
            elsif @in_groups
              case name
              when 'groupName'
                @group[:group_name] = @value
              when 'groups'
                @in_groups = false
              when 'item'
                unless @group == {}
                  @ip_permission[:groups] << @group
                end
                @group = {}
              when 'userId'
                @group[:user_id] = @value
              end
            elsif @in_ip_ranges
              case name
              when 'cidrIp'
                @ip_range[:cidr_ip] = @value
              when 'ipRanges'
                @in_ip_ranges = false
              when 'item'
                unless @ip_range == {}
                  @ip_permission[:ip_ranges] << @ip_range
                end
                @ip_range = {}
              end
            elsif @in_ip_permissions
              case name
              when 'fromPort'
                @item[:from_port] = @value
              when 'item'
                @item[:ip_permissions] << @ip_permission
                @ip_permission = { :groups => [], :ip_ranges => []}
              when 'ipProtocol'
                @ip_permission[:ip_protocol] = @value
              when 'ipPermissions'
                @in_ip_permissions = false
              when 'toPort'
                @item[:to_port] = @value
              end
            end
          end

        end

        class DescribeSnapshots < Fog::Parsers::Base

          def reset
            @response = { :snapshot_set => [] }
            @snapshot = {}
          end

          def end_element(name)
            case name
            when 'item'
              @response[:snapshot_set] << @snapshot
              @snapshot = {}
            when 'progress'
              @snapshot[:progress] = @value
            when 'snapshotId'
              @snapshot[:snapshot_id] = @value
            when 'startTime'
              @snapshot[:start_time] = Time.parse(@value)
            when 'status'
              @snapshot[:status] = @value
            when 'volumeId'
              @snapshot[:volume_id] = @value
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