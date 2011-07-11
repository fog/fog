module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'

        # Sets the certificate that terminates the specified listener's SSL
        # connections. The specified certificate replaces any prior certificate
        # that was used on the same LoadBalancer and port.
        #
        # ==== Parameters
        # * lb_name<~String> - Name of the ELB
        # * load_balancer_port<~Integer> - The external port of the LoadBalancer
        #   with which this policy has to be associated.
        # * ssl_certificate_id<~String> - ID of the SSL certificate chain to use
        #   example: arn:aws:iam::322191361670:server-certificate/newCert
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def set_load_balancer_listener_ssl_certificate(lb_name, load_balancer_port, ssl_certificate_id)
          request({
            'Action'           => 'SetLoadBalancerListenerSSLCertificate',
            'LoadBalancerName' => lb_name,
            'LoadBalancerPort' => load_balancer_port,
            'SSLCertificateId' => ssl_certificate_id,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          })
        end

      end

      class Mock
      end
    end
  end
end
