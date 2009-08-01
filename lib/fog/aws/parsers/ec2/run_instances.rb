module Fog
  module Parsers
    module AWS
      module EC2

        class RunInstances < Fog::Parsers::Base

          def reset
            @instance = { 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
            @response = { 'groupSet' => [], 'instancesSet' => [] }
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
              @instance[name] = @value.to_i
            when 'availabilityZone'
              @instance['placement'][name] = @value
            when 'code'
              @instance['instanceState'][name] = @value.to_i
            when 'dnsName', 'kernelId', 'keyName', 'imageId', 'instanceId', 'instanceType', 'platform', 'privateDnsName', 'ramdiskId', 'reason', 'requestorId'
              @instance[name] = @value
            when 'groupId'
              @response['groupSet'] << @value
            when 'groupSet'
              @in_group_set = false
            when 'item'
              unless @in_group_set || @in_product_codes
                @response['instancesSet'] << @instance
                @instance = { 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
              end
            when 'launchTime'
              @instance[name] = Time.parse(@value)
            when 'name'
              @instance['instanceState'][name] = @value
            when 'ownerId', 'requestId', 'reservationId'
              @response[name] = @value
            when 'product_code'
              @instance['productCodes'] << @value
            when 'productCodes'
              @in_product_codes = false
            when 'state'
              if @value == 'true'
                @instance['monitoring'][name] = true
              else
                @instance['monitoring'][name] = false
              end
            end
          end

        end

      end
    end
  end
end
