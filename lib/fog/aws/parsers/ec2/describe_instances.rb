module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeInstances < Fog::Parsers::Base

          def reset
            @instance = { 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
            @reservation = { 'groupSet' => [], 'instancesSet' => [] }
            @response = { 'reservationSet' => [] }
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
              @instance[name] = @value.to_i
            when 'availabilityZone'
              @instance['placement'][name] = @value
            when 'code'
              @instance['instanceState'][name] = @value.to_i
            when 'dnsName', 'imageId', 'instanceId', 'instanceType', 'kernelId', 'keyName', 'privateDnsName', 'ramdiskId', 'reason'
              @instance[name] = @value
            when 'groupId'
              @reservation['groupSet'] << @value
            when 'groupSet'
              @in_subset = false
            when 'instancesSet'
              @in_instances_set = false
            when 'item'
              if @in_instances_set
                @reservation['instancesSet'] << @instance
                @instance = { 'instanceState' => {}, 'monitoring' => {}, 'placement' => {}, 'productCodes' => [] }
              elsif !@in_subset
                @response['reservationSet'] << @reservation
                @reservation = { 'groupSet' => [], 'instancesSet' => [] }
              end
            when 'launchTime'
              @instance[name] = Time.parse(@value)
            when 'name'
              @instance['instanceState'][name] = @value
            when 'ownerId', 'reservationId'
              @reservation[name] = @value
            when 'requestId'
              @response[name] = @value
            when 'productCode'
              @instance['productCodes'] << @value
            when 'productCodes'
              @in_subset = false
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
