module Fog
  module Parsers
    module AWS
      module EC2

        class RunInstances < Fog::Parsers::Base

          def reset
            @instance = { :instance_state => {}, :monitoring => {}, :placement => {}, :product_codes => [] }
            @response = { :group_set => [], :instances_set => [] }
          end

          def start_element(name, attrs = [])
            if name == 'groupSet'
              @in_group_set = true
            elsif name == 'productCodes'
              @in_product_codes = true
            end
            @value = ''
          end

          def end_element(name)
            case name
            when 'amiLaunchIndex'
              @instance[:ami_launch_index] = @value.to_i
            when 'availabilityZone'
              @instance[:placement][:availability_zone] = @value
            when 'code'
              @instance[:instance_state][:code] = @value.to_i
            when 'dnsName'
              @instance[:dns_name] = @value
            when 'groupId'
              @response[:group_set] << @value
            when 'groupSet'
              @in_group_set = false
            when 'kernelId'
              @instance[:kernel_id] = @value
            when 'keyName'
              @instance[:key_name] = @value
            when 'imageId'
              @instance[:image_id] = @value
            when 'instanceId'
              @instance[:instance_id] = @value
            when 'instanceType'
              @instance[:instance_type] = @value
            when 'item'
              unless @in_group_set || @in_product_codes
                @response[:instances_set] << @instance
                @instance = { :instance_state => {}, :monitoring => {}, :placement => {}, :product_codes => [] }
              end
            when 'kernelId'
              @instance[:kernel_id] = @value
            when 'launchTime'
              @instance[:launch_time] = Time.parse(@value)
            when 'name'
              @instance[:instance_state][:name] = @value
            when 'ownerId'
              @response[:owner_id] = @value
            when 'platform'
              @instance[:platform] = @value
            when 'privateDnsName'
              @instance[:private_dns_name] = @value
            when 'product_code'
              @instance[:product_codes] << @value
            when 'productCodes'
              @in_product_codes = false
            when 'ramdiskId'
              @instance[:ramdisk_id] = @value
            when 'reason'
              @instance[:reason] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'requestorId'
              @instance[:requestor_id] = @value
            when 'reservationId'
              @response[:reservation_id] = @value
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
