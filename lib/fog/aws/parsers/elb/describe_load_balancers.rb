module Fog
  module Parsers
    module AWS
      module ELB

        class DescribeLoadBalancers < Fog::Parsers::Base

          def reset
            reset_load_balancer
            reset_listener_description
            reset_policy
            @results = { 'LoadBalancerDescriptions' => [] }
            @response = { 'DescribeLoadBalancersResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_load_balancer
            @load_balancer = { 'ListenerDescriptions' => [], 'Instances' => [], 'AvailabilityZones' => [], 'Policies' => {'AppCookieStickinessPolicies' => [], 'LBCookieStickinessPolicies' => [] }, 'HealthCheck' => {}, 'SourceSecurityGroup' => {} }
          end

          def reset_listener_description
            @listener_description = { 'PolicyNames' => [], 'Listener' => {} }
          end

          def reset_policy
            @policy = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'ListenerDescriptions'
              @in_listeners = true
            when 'Instances'
              @in_instances = true
            when 'AvailabilityZones'
              @in_availability_zones = true
            when 'PolicyNames'
              @in_policy_names = true
            when 'Policies'
              @in_policies = true
            when 'LBCookieStickinessPolicies'
              @in_lb_cookies = true
            when 'AppCookieStickinessPolicies'
              @in_app_cookies = true
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_policy_names
                @listener_description['PolicyNames'] << value
              elsif @in_availability_zones
                @load_balancer['AvailabilityZones'] << value
              elsif @in_listeners
                @load_balancer['ListenerDescriptions'] << @listener_description
                reset_listener_description
              elsif @in_app_cookies
                @load_balancer['Policies']['AppCookieStickinessPolicies'] << @policy
                reset_policy
              elsif @in_lb_cookies
                @load_balancer['Policies']['LBCookieStickinessPolicies'] << @policy
                reset_policy
              elsif !@in_instances && !@in_policies
                @results['LoadBalancerDescriptions'] << @load_balancer
                reset_load_balancer
              end

            when 'CanonicalHostedZoneName', 'CanonicalHostedZoneNameID', 'LoadBalancerName', 'DNSName'
              @load_balancer[name] = value
            when 'CreatedTime'
              @load_balancer[name] = Time.parse(value)

            when 'ListenerDescriptions'
              @in_listeners = false
            when 'PolicyNames'
              @in_policy_names = false
            when 'Protocol', 'SSLCertificateId'
              @listener_description['Listener'][name] = value
            when 'LoadBalancerPort', 'InstancePort'
              @listener_description['Listener'][name] = value.to_i

            when 'Instances'
              @in_instances = false
            when 'InstanceId'
              @load_balancer['Instances'] << value

            when 'AvailabilityZones'
              @in_availability_zones = false

            when 'Policies'
              @in_policies = false
            when 'AppCookieStickinessPolicies'
              @in_app_cookies = false
            when 'LBCookieStickinessPolicies'
              @in_lb_cookies = false

            when 'OwnerAlias', 'GroupName'
              @load_balancer['SourceSecurityGroup'][name] = value

            when 'Interval', 'HealthyThreshold', 'Timeout', 'UnhealthyThreshold'
              @load_balancer['HealthCheck'][name] = value.to_i
            when 'Target'
              @load_balancer['HealthCheck'][name] = value

            when 'PolicyName', 'CookieName'
              @policy[name] = value
            when 'CookieExpirationPeriod'
              @policy[name] = value.to_i

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'DescribeLoadBalancersResponse'
              @response['DescribeLoadBalancersResult'] = @results
            end
          end

        end

      end
    end
  end
end
