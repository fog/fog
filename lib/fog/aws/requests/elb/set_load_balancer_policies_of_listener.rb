module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'

        # Associates, updates, or disables a policy with a listener on the
        # load balancer. Currently only zero (0) or one (1) policy can be
        # associated with a listener.
        #
        # ==== Parameters
        # * lb_name<~String> - Name of the ELB
        # * load_balancer_port<~Integer> - The external port of the LoadBalancer
        #   with which this policy has to be associated.

        # * policy_names<~Array> - List of policies to be associated with the
        #   listener. Currently this list can have at most one policy. If the
        #   list is empty, the current policy is removed from the listener.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def set_load_balancer_policies_of_listener(lb_name, load_balancer_port, policy_names)
          params = {'LoadBalancerPort' => load_balancer_port}
          if policy_names.any?
            params.merge!(Fog::AWS.indexed_param('PolicyNames.member', policy_names))
          else
            params['PolicyNames'] = ''
          end

          request({
            'Action'           => 'SetLoadBalancerPoliciesOfListener',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          }.merge!(params))
        end

      end
    end
  end
end
