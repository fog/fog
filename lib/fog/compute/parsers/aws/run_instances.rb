module Fog
  module Parsers
    module Compute
      module AWS

        class RunInstances < Fog::Parsers::Base

          def reset
            @block_device_mapping = {}
            @instance = { 'blockDeviceMapping' => [], 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
            @response = { 'groupSet' => [], 'instancesSet' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'blockDeviceMapping'
              @in_block_device_mapping = true
            when 'groupSet'
              @in_group_set = true
            when 'productCodes'
              @in_product_codes = true
            end
          end

          def end_element(name)
            case name
            when 'amiLaunchIndex'
              @instance[name] = value.to_i
            when 'architecture', 'clientToken', 'dnsName', 'imageId',
                  'instanceId', 'instanceType', 'ipAddress', 'kernelId',
                  'keyName', 'privateDnsName', 'privateIpAddress', 'ramdiskId',
                  'reason', 'rootDeviceType'
              @instance[name] = value
            when 'availabilityZone'
              @instance['placement'][name] = value
            when 'attachTime'
              @block_device_mapping[name] = Time.parse(value)
            when 'blockDeviceMapping'
              @in_block_device_mapping = false
            when 'code'
              @instance['instanceState'][name] = value.to_i
            when 'deleteOnTermination'
              @block_device_mapping[name] = (value == 'true')
            when 'deviceName', 'status', 'volumeId'
              @block_device_mapping[name] = value
            when 'groupId'
              @response['groupSet'] << value
            when 'groupSet'
              @in_group_set = false
            when 'item'
              if @in_block_device_mapping
                @instance['blockDeviceMapping'] << @block_device_mapping
                @block_device_mapping = {}
              elsif !@in_group_set && !@in_product_codes
                @response['instancesSet'] << @instance
                @instance = { 'blockDeviceMapping' => [], 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
              end
            when 'launchTime'
              @instance[name] = Time.parse(value)
            when 'name'
              @instance['instanceState'][name] = value
            when 'ownerId', 'requestId', 'reservationId'
              @response[name] = value
            when 'product_code'
              @instance['productCodes'] << value
            when 'productCodes'
              @in_product_codes = false
            when 'state'
              @instance['monitoring'][name] = (value == 'true')
            when 'subnetId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
