module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'

        # Delete a Load Balancer Stickiness Policy
        #
        # ==== Parameters
        # * lb_name<~String> - Name of the ELB
        # * policy_name<~String> - The name of the policy to delete
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_load_balancer_policy(lb_name, policy_name)
          params = {'PolicyName' => policy_name}

          request({
            'Action'           => 'DeleteLoadBalancerPolicy',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          }.merge!(params))
        end

      end
    end
  end
end
