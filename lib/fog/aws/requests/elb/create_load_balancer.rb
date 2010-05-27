module Fog
  module AWS
    module ELB
      class Real

        # Create a new Elastic Load Balancer
        #
        # ==== Parameters
        # * availability_zones<~Array> - List of availability zones for the ELB
        # * lb_name<~String> - Name for the new ELB -- must be unique
        # * listeners<~Array> - Array of Hashes describing ELB listeners to assign to the ELB
        #   * 'Protocol'<~String> - Protocol to use. Either HTTP or TCP.
        #   * 'LoadBalancerPort'<~Integer> - The port that the ELB will listen to for outside traffic
        #   * 'InstancePort'<~Integer> - The port on the instance that the ELB will forward traffic to
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'CreateLoadBalancerResult'<~Hash>:
        #       * 'DNSName'<~String> - DNS name for the newly created ELB
        def create_load_balancer(availability_zones, lb_name, listeners)
          params = ELB.indexed_param('AvailabilityZones.member', [*availability_zones], 1)

          listener_protocol = []
          listener_lb_port = []
          listener_instance_port = []
          listeners.each do |listener|
            listener_protocol.push(listener['Protocol'])
            listener_lb_port.push(listener['LoadBalancerPort'])
            listener_instance_port.push(listener['InstancePort'])
          end

          params.merge!(ELB.indexed_param('Listeners.member.%.Protocol', listener_protocol, 1))
          params.merge!(ELB.indexed_param('Listeners.member.%.LoadBalancerPort', listener_lb_port, 1))
          params.merge!(ELB.indexed_param('Listeners.member.%.InstancePort', listener_instance_port, 1))

          request({
            'Action'           => 'CreateLoadBalancer',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::CreateLoadBalancer.new
          }.merge!(params))
        end

      end

      class Mock

        def create_load_balancer(availability_zones, lb_name, listeners)
          raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
        end

      end

    end
  end
end
