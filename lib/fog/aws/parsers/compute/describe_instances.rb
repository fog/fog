module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeInstances < Fog::Parsers::Base

          def reset
            @block_device_mapping = {}
            @context = []
            @contexts = ['blockDeviceMapping', 'groupSet', 'instancesSet', 'instanceState', 'placement', 'productCodes', 'stateReason', 'tagSet']
            @instance = { 'blockDeviceMapping' => [], 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [], 'stateReason' => {}, 'tagSet' => {} }
            @reservation = { 'groupSet' => [], 'instancesSet' => [] }
            @response = { 'reservationSet' => [] }
            @tag = {}
          end

          def start_element(name, attrs = [])
            super
            if @contexts.include?(name)
              @context.push(name)
            end
          end

          def end_element(name)
            case name
            when 'amiLaunchIndex'
              @instance[name] = value.to_i
            when 'availabilityZone', 'tenancy'
              @instance['placement'][name] = value
            when 'architecture', 'clientToken', 'dnsName', 'imageId',
                  'instanceId', 'instanceType', 'ipAddress', 'kernelId',
                  'keyName', 'platform', 'privateDnsName', 'privateIpAddress', 'ramdiskId',
                  'reason', 'rootDeviceType'
              @instance[name] = value
            when 'attachTime'
              @block_device_mapping[name] = Time.parse(value)
            when *@contexts
              @context.pop
            when 'code'
              @instance[@context.last][name] = value.to_i
            when 'deleteOnTermination'
              @block_device_mapping[name] = (value == 'true')
            when 'deviceName', 'status', 'volumeId'
              @block_device_mapping[name] = value
            when 'groupId', 'groupName'
              case @context.last
              when 'groupSet'
                @reservation['groupSet'] << value
              when 'placement'
                @instance['placement'][name] = value
              end
            when 'item'
              case @context.last
              when 'blockDeviceMapping'
                @instance['blockDeviceMapping'] << @block_device_mapping
                @block_device_mapping = {}
              when 'instancesSet'
                @reservation['instancesSet'] << @instance
                @instance = { 'blockDeviceMapping' => [], 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [], 'stateReason' => {}, 'tagSet' => {} }
              when 'tagSet'
                @instance['tagSet'][@tag['key']] = @tag['value']
                @tag = {}
              when nil
                @response['reservationSet'] << @reservation
                @reservation = { 'groupSet' => [], 'instancesSet' => [] }
              end
            when 'key', 'value'
              @tag[name] = value
            when 'launchTime'
              @instance[name] = Time.parse(value)
            when 'name'
              @instance[@context.last][name] = value
            when 'ownerId', 'reservationId'
              @reservation[name] = value
            when 'requestId'
              @response[name] = value
            when 'productCode'
              @instance['productCodes'] << value
            when 'state'
              @instance['monitoring'][name] = (value == 'true')
            end
          end

        end

      end
    end
  end
end
