module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/describe_load_balancer_attributes'

        # Describe the load balancer attributes
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DescribeLoadBalancerAttributes.html
        # ==== Parameters
        # * lb_name<~String> - The mnemonic name associated with the LoadBalancer. 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeLoadBalancerAttributesResult'<~Hash>:
        #       * 'LoadBalancerAttributes'<~Hash>
        #         * 'CrossZoneLoadBalancing'<~Hash>
        #           * 'Enabled'<~Boolean> - whether crosszone load balancing is enabled
        def describe_load_balancer_attributes(lb_name)
          request({
            'Action'  => 'DescribeLoadBalancerAttributes',
            'LoadBalancerName' => lb_name,
            :parser   => Fog::Parsers::AWS::ELB::DescribeLoadBalancerAttributes.new
          })
        end

      end

      class Mock
        def describe_load_balancer_attributes(lb_name = nil, names = [])
          raise Fog::AWS::ELB::NotFound unless load_balancer = self.data[:load_balancers][lb_name]
          attributes = load_balancer['LoadBalancerAttributes']

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeLoadBalancerAttributesResult' => {
              'LoadBalancerAttributes' => attributes
            }
          }

          response
        end
      end
    end
  end
end
