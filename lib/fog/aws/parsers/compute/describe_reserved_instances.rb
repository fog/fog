module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeReservedInstances < Fog::Parsers::Base
          def get_default_item
            {'tagSet' => {}, 'recurringCharges' => {}}
          end

          def reset
            @context = []
            # Note:  <recurringCharges> should also be handled as a set, but do not want to disrupt anyone relying on
            # it currently being flatted
            @contexts = ['reservedInstancesSet', 'tagSet']
            @reserved_instance = get_default_item
            @response = { 'reservedInstancesSet' => [] }
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
            when 'availabilityZone', 'instanceType', 'productDescription', 'reservedInstancesId', 'state', 'offeringType'
              @reserved_instance[name] = value
            when 'duration', 'instanceCount'
              @reserved_instance[name] = value.to_i
            when 'fixedPrice', 'amount', 'usagePrice'
              @reserved_instance[name] = value.to_f
            when *@contexts
              @context.pop
            when 'item'
              case @context.last
              when 'reservedInstancesSet'
                @response['reservedInstancesSet'] << @reserved_instance
                @reserved_instance = get_default_item
              when 'tagSet'
                @reserved_instance['tagSet'][@tag['key']] = @tag['value']
                @tag = {}
              end
            when 'key', 'value'
              @tag[name] = value
            when 'requestId'
              @response[name] = value
            when 'start','end'
              @reserved_instance[name] = Time.parse(value)
            end
          end
        end
      end
    end
  end
end
