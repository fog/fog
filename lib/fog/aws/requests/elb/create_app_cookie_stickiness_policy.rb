module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'

        # Create an app cookie stickiness policy
        #
        # ==== Parameters
        # * lb_name<~String> - Name of the ELB
        # * policy_name<~String> - The name of the policy being created.
        #   The name must be unique within the set of policies for this Load Balancer.
        # * cookie_name<~String> - Name of the application cookie used for stickiness.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def create_app_cookie_stickiness_policy(lb_name, policy_name, cookie_name)
          params = {'CookieName' => cookie_name, 'PolicyName' => policy_name}

          request({
            'Action'           => 'CreateAppCookieStickinessPolicy',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          }.merge!(params))
        end

      end
    end
  end
end
