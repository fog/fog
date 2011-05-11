require 'fog/aws/models/elb/load_balancer'
module Fog
  module AWS
    class ELB
      class LoadBalancers < Fog::Collection
        model Fog::AWS::ELB::LoadBalancer

        # Creates a new load balancer
        def initialize(attributes={})
          super
        end

        def all
          data = connection.describe_load_balancers.body['DescribeLoadBalancersResult']['LoadBalancerDescriptions']
          load(data)
        end

        def get(identity)
          data = connection.describe_load_balancers(identity).body['DescribeLoadBalancersResult']['LoadBalancerDescriptions'].first
          new(data)
        rescue Fog::AWS::ELB::NotFound
          nil
        end

      end
    end
  end
end
