module Fog
  module Parsers
    module AWS
      module ELB

        class DescribeLoadBalancerAttributes < Fog::Parsers::Base

          def reset
            @response = { 'DescribeLoadBalancerAttributesResult' => { 'LoadBalancerAttributes' => {} }, 'ResponseMetadata' => {} }
            @stack = []
          end

          def start_element(name, attrs = [])
            super
            case name 
            when 'CrossZoneLoadBalancing'
              @cross_zone_load_balancing = {}
            end
          end

          def end_element(name)
            case name
            when 'Enabled'
              if @cross_zone_load_balancing
                @cross_zone_load_balancing['Enabled'] = value == 'true' ? true : false
              end
            when 'CrossZoneLoadBalancing'
              @response['DescribeLoadBalancerAttributesResult']['LoadBalancerAttributes']['CrossZoneLoadBalancing'] = @cross_zone_load_balancing
              @cross_zone_load_balancing = nil
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end

        end

      end
    end
  end
end
