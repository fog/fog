module Fog
  module AWS
    module ELB
      class Real

        # Deregister an instance from an existing ELB
        #
        # ==== Parameters
        # * instance_ids<~Array> - List of instance IDs to remove from ELB
        # * lb_name<~String> - Load balancer to remove instances from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DeregisterInstancesFromLoadBalancerResult'<~Hash>:
        #       * 'Instances'<~Array> - array of hashes describing instances currently enabled
        #         * 'InstanceId'<~String>
        def deregister_instances_from_load_balancer(instance_ids, lb_name)
          params = ELB.indexed_param('Instances.member.%.InstanceId', [*instance_ids], 1)
          request({
            'Action'           => 'DeregisterInstancesFromLoadBalancer',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::DeregisterInstancesFromLoadBalancer.new
          }.merge!(params))
        end

        alias :deregister_instances :deregister_instances_from_load_balancer

      end

      class Mock

        def deregister_instances_from_load_balancer(instance_ids, lb_name)
          raise MockNotImplemented.new("Contributions welcome!")
        end

        alias :deregister_instances :deregister_instances_from_load_balancer

      end

    end
  end
end
