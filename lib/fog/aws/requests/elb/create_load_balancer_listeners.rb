module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'

        # Create Elastic Load Balancer Listeners
        #
        # ==== Parameters
        # * lb_name<~String> - Name for the new ELB -- must be unique
        # * listeners<~Array> - Array of Hashes describing ELB listeners to add to the ELB
        #   * 'Protocol'<~String> - Protocol to use. Either HTTP or TCP.
        #   * 'LoadBalancerPort'<~Integer> - The port that the ELB will listen to for outside traffic
        #   * 'InstancePort'<~Integer> - The port on the instance that the ELB will forward traffic to
        #   * 'SSLCertificateId'<~String> - ARN of the server certificate
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def create_load_balancer_listeners(lb_name, listeners)
          params = {}

          listener_protocol = []
          listener_lb_port = []
          listener_instance_port = []
          listener_ssl_certificate_id = []
          listeners.each do |listener|
            listener_protocol.push(listener['Protocol'])
            listener_lb_port.push(listener['LoadBalancerPort'])
            listener_instance_port.push(listener['InstancePort'])
            listener_ssl_certificate_id.push(listener['SSLCertificateId'])
          end

          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.Protocol', listener_protocol))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.LoadBalancerPort', listener_lb_port))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.InstancePort', listener_instance_port))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.SSLCertificateId', listener_ssl_certificate_id))

          request({
            'Action'           => 'CreateLoadBalancerListeners',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          }.merge!(params))
        end

      end
    end
  end
end
