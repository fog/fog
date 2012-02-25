module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/create_load_balancer'

        # Create a new Elastic Load Balancer
        #
        # ==== Parameters
        # * availability_zones<~Array> - List of availability zones for the ELB
        # * lb_name<~String> - Name for the new ELB -- must be unique
        # * listeners<~Array> - Array of Hashes describing ELB listeners to assign to the ELB
        #   * 'Protocol'<~String> - Protocol to use. Either HTTP, HTTPS, TCP or SSL.
        #   * 'LoadBalancerPort'<~Integer> - The port that the ELB will listen to for outside traffic
        #   * 'InstancePort'<~Integer> - The port on the instance that the ELB will forward traffic to
        #   * 'InstanceProtocol'<~String> - Protocol for sending traffic to an instance. Either HTTP, HTTPS, TCP or SSL.
        #   * 'SSLCertificateId'<~String> - ARN of the server certificate
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'CreateLoadBalancerResult'<~Hash>:
        #       * 'DNSName'<~String> - DNS name for the newly created ELB
        def create_load_balancer(availability_zones, lb_name, listeners)
          params = Fog::AWS.indexed_param('AvailabilityZones.member', [*availability_zones])

          listener_protocol = []
          listener_lb_port = []
          listener_instance_port = []
          listener_instance_protocol = []
          listener_ssl_certificate_id = []
          listeners.each do |listener|
            listener_protocol.push(listener['Protocol'])
            listener_lb_port.push(listener['LoadBalancerPort'])
            listener_instance_port.push(listener['InstancePort'])
            listener_instance_protocol.push(listener['InstanceProtocol'])
            listener_ssl_certificate_id.push(listener['SSLCertificateId'])
          end

          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.Protocol', listener_protocol))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.LoadBalancerPort', listener_lb_port))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.InstancePort', listener_instance_port))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.InstanceProtocol', listener_instance_protocol))
          params.merge!(Fog::AWS.indexed_param('Listeners.member.%d.SSLCertificateId', listener_ssl_certificate_id))

          request({
            'Action'           => 'CreateLoadBalancer',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::CreateLoadBalancer.new
          }.merge!(params))
        end
      end

      class Mock
        def create_load_balancer(availability_zones, lb_name, listeners = [])
          response = Excon::Response.new
          response.status = 200

          raise Fog::AWS::ELB::IdentifierTaken if self.data[:load_balancers].has_key? lb_name

          certificate_ids = Fog::AWS::IAM::Mock.data[@aws_access_key_id][:server_certificates].map {|n, c| c['Arn'] }

          listeners = [*listeners].map do |listener|
            if listener['SSLCertificateId'] and !certificate_ids.include? listener['SSLCertificateId']
              raise Fog::AWS::IAM::NotFound.new('CertificateNotFound')
            end
            {'Listener' => listener, 'PolicyNames' => []}
          end

          dns_name = Fog::AWS::ELB::Mock.dns_name(lb_name, @region)
          self.data[:load_balancers][lb_name] = {
            'AvailabilityZones' => availability_zones,
            'CanonicalHostedZoneName' => '',
            'CanonicalHostedZoneNameID' => '',
            'CreatedTime' => Time.now,
            'DNSName' => dns_name,
            'HealthCheck' => {
              'HealthyThreshold' => 10,
              'Timeout' => 5,
              'UnhealthyThreshold' => 2,
              'Interval' => 30,
              'Target' => 'TCP:80'
            },
            'Instances' => [],
            'ListenerDescriptions' => listeners,
            'LoadBalancerName' => lb_name,
            'Policies' => {
              'AppCookieStickinessPolicies' => [],
              'LBCookieStickinessPolicies' => [],
              'Proper' => []
            },
            'SourceSecurityGroup' => {
              'GroupName' => '',
              'OwnerAlias' => ''
            }
          }

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'CreateLoadBalancerResult' => {
              'DNSName' => dns_name
            }
          }

          response
        end
      end
    end
  end
end
