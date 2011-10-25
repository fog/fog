module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/describe_load_balancers'

        # Describe all or specified load balancers
        #
        # ==== Parameters
        # * lb_name<~Array> - List of load balancer names to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeLoadBalancersResult'<~Hash>:
        #       * 'LoadBalancerDescriptions'<~Array>
        #         * 'AvailabilityZones'<~Array> - list of availability zones covered by this load balancer
        #         * 'CanonicalHostedZoneName'<~String> - name of the Route 53 hosted zone associated with the load balancer
        #         * 'CanonicalHostedZoneNameID'<~String> - ID of the Route 53 hosted zone associated with the load balancer
        #         * 'CreatedTime'<~Time> - time load balancer was created
        #         * 'DNSName'<~String> - external DNS name of load balancer
        #         * 'HealthCheck'<~Hash>:
        #           * 'HealthyThreshold'<~Integer> - number of consecutive health probe successes required before moving the instance to the Healthy state
        #           * 'Timeout'<~Integer> - number of seconds after which no response means a failed health probe
        #           * 'Interval'<~Integer> - interval (in seconds) between health checks of an individual instance
        #           * 'UnhealthyThreshold'<~Integer> - number of consecutive health probe failures that move the instance to the unhealthy state
        #           * 'Target'<~String> - string describing protocol type, port and URL to check
        #         * 'Instances'<~Array> - list of instances that the load balancer balances between
        #         * 'ListenerDescriptions'<~Array>
        #           * 'PolicyNames'<~Array> - list of policies enabled
        #           * 'Listener'<~Hash>:
        #             * 'InstancePort'<~Integer> - port on instance that requests are sent to
        #             * 'Protocol'<~String> - transport protocol used for routing in [TCP, HTTP]
        #             * 'LoadBalancerPort'<~Integer> - port that load balancer listens on for requests
        #         * 'LoadBalancerName'<~String> - name of load balancer
        #         * 'Policies'<~Hash>:
        #           * 'LBCookieStickinessPolicies'<~Array> - list of Load Balancer Generated Cookie Stickiness policies for the LoadBalancer
        #           * 'AppCookieStickinessPolicies'<~Array> - list of Application Generated Cookie Stickiness policies for the LoadBalancer
        #         * 'SourceSecurityGroup'<~Hash>:
        #           * 'GroupName'<~String> - Name of the source security group to use with inbound security group rules
        #           * 'OwnerAlias'<~String> - Owner of the source security group
        def describe_load_balancers(lb_name = [])
          params = Fog::AWS.indexed_param('LoadBalancerNames.member', [*lb_name])
          request({
            'Action'  => 'DescribeLoadBalancers',
            :parser   => Fog::Parsers::AWS::ELB::DescribeLoadBalancers.new
          }.merge!(params))
        end

      end

      class Mock
        def describe_load_balancers(lb_names = [])
          lb_names = [*lb_names]
          load_balancers = if lb_names.any?
            lb_names.map do |lb_name|
              lb = self.data[:load_balancers].find { |name, data| name == lb_name }
              raise Fog::AWS::ELB::NotFound unless lb
              lb[1].dup
            end.compact
          else
            self.data[:load_balancers].map { |lb, values| values.dup }
          end

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeLoadBalancersResult' => {
              'LoadBalancerDescriptions' => load_balancers.map { |lb| lb['Instances'] = lb['Instances'].map { |i| i['InstanceId'] }; lb }
            }
          }

          response
        end
      end
    end
  end
end
