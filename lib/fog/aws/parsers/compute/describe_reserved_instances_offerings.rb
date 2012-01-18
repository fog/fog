module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeReservedInstancesOfferings < Fog::Parsers::Base

          def reset
            @reserved_instances_offering = {}
            @response = { 'reservedInstancesOfferingsSet' => [] }
          end

          def end_element(name)
            case name
            when 'availabilityZone', 'currencyCode', 'instanceType', 'instanceTenancy', 'productDescription', 'reservedInstancesOfferingId'
              @reserved_instances_offering[name] = value
            when 'duration'
              @reserved_instances_offering[name] = value.to_i
            when 'fixedPrice', 'usagePrice'
              @reserved_instances_offering[name] = value.to_f
            when 'item'
              @response['reservedInstancesOfferingsSet'] << @reserved_instances_offering
              @reserved_instances_offering = {}
            when 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
