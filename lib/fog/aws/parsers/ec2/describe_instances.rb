module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeInstances < Fog::Parsers::Base

          def reset
            @instance = { :instance_state => {}, :monitoring => {}, :placement => [], :product_codes => [] }
            @reservation = { :group_set => [], :instances_set => [] }
            @response = { :reservation_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'groupSet' || name == 'productCodes'
              @in_subset = true
            elsif name == 'instancesSet'
              @in_instances_set = true
            end
            @value = ''
          end

          def end_element(name)
            case name
            when 'amiLaunchIndex'
              @instance[:ami_launch_index] = @value
            when 'availabilityZone'
              @instance[:placement] << @value
            when 'code'
              @instance[:instance_state][:code] = @value
            when 'dnsName'
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
                @instance = { :instance_state => {}, :monitoring => {}, :placement => [], :product_codes => [] }
              elsif !@in_subset
                @response[:reservation_set] << @reservation
                @reservation = { :group_set => [], :instances_set => [] }
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
            when 'ramdiskId'
              @instance[:ramdisk_id] = @value
            when 'reason'
              @instance[:reason] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'reservationId'
              @reservation[:reservation_id] = @value
            when 'privateDnsName'
              @instance[:private_dns_name] = @value
            when 'productCode'
              @instance[:product_codes] << @value
            when 'productCodes'
              @in_subset = false
            when 'ramdiskId'
              @instance[:ramdisk_id] = @value
            when 'state'
              if @value == 'true'
                @instance[:monitoring][:state] = true
              else
                @instance[:monitoring][:state] = false
              end
            end
          end

        end

      end
    end
  end
end
