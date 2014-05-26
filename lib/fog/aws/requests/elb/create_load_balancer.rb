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
        def create_load_balancer(availability_zones, lb_name, listeners, options = {})
          params = Fog::AWS.indexed_param('AvailabilityZones.member', [*availability_zones])
          params.merge!(Fog::AWS.indexed_param('Subnets.member.%d', options[:subnet_ids]))
          params.merge!(Fog::AWS.serialize_keys('Scheme', options[:scheme]))
          params.merge!(Fog::AWS.indexed_param('SecurityGroups.member.%d', options[:security_groups]))

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
        def create_load_balancer(availability_zones, lb_name, listeners = [], options = {})
          response = Excon::Response.new
          response.status = 200

          raise Fog::AWS::ELB::IdentifierTaken if self.data[:load_balancers].key? lb_name

          certificate_ids = Fog::AWS::IAM::Mock.data[@aws_access_key_id][:server_certificates].map { |_n, c| c['Arn'] }

          listeners = [*listeners].map do |listener|
            if listener['SSLCertificateId'] and !certificate_ids.include? listener['SSLCertificateId']
              raise Fog::AWS::IAM::NotFound.new('CertificateNotFound')
            end
            {'Listener' => listener, 'PolicyNames' => []}
          end

          dns_name = Fog::AWS::ELB::Mock.dns_name(lb_name, @region)

          availability_zones = [*availability_zones].compact
          region = availability_zones.empty? ? "us-east-1" : availability_zones.first.gsub(/[a-z]$/, '')
          supported_platforms = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:account_attributes].find { |h| h["attributeName"] == "supported-platforms" }["values"]
          subnet_ids = options[:subnet_ids] || []
          subnets = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:subnets].select { |e| subnet_ids.include?(e["subnetId"]) }

          # http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/default-vpc.html
          elb_location = if supported_platforms.include?("EC2")
                           if subnet_ids.empty?
                             'EC2-Classic'
                           else
                             'EC2-VPC'
                           end
                         else
                           if subnet_ids.empty?
                             'EC2-VPC-Default'
                           else
                             'VPC'
                           end
                         end

          security_group = case elb_location
                           when 'EC2-Classic'
                             Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups]['amazon-elb-sg']
                           when 'EC2-VPC-Default'
                             # find or create default vpc
                             unless vpc = Fog::Compute[:aws].vpcs.all.first
                               vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.0.0/24')
                             end

                             default_sg = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups].values.find { |sg|
                               sg['groupName'] =~ /^default_elb/ &&
                                 sg["vpcId"] == vpc.id
                             }

                             unless default_sg
                               default_sg = {
                                 'groupDescription'    => 'default_elb security group',
                                             'groupName'           => "default_elb_#{Fog::Mock.random_hex(6)}",
                                             'groupId'             => Fog::AWS::Mock.security_group_id,
                                             'ipPermissionsEgress' => [],
                                             'ipPermissions'       => [],
                                             'ownerId'             => self.data[:owner_id],
                                             'vpcId'               => vpc.id
                                            }
                               Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups]['default'] = default_sg
                             end

                             default_sg
                           when 'EC2-VPC'
                             # find or create default vpc security group
                             vpc_id = subnets.first["vpcId"]
                             default_sg = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups].values.find { |sg|
                               sg['groupName'] == 'default' &&
                                 sg["vpcId"] == vpc_id
                             }

                             unless default_sg
                               default_sg = {
                                 'groupDescription'    => 'default elb security group',
                                             'groupName'           => 'default',
                                             'groupId'             => Fog::AWS::Mock.security_group_id,
                                             'ipPermissionsEgress' => [],
                                             'ipPermissions'       => [],
                                             'ownerId'             => self.data[:owner_id],
                                             'vpcId'               => vpc_id
                                            }
                               Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:security_groups]['default'] = default_sg
                             end

                             default_sg
                           end

          self.data[:load_balancers][lb_name] = {
            'AvailabilityZones' => availability_zones,
            'BackendServerDescriptions' => [],
            # Hack to facilitate not updating the local data structure
            # (BackendServerDescriptions) until we do a subsequent
            # describe as that is how AWS behaves.
            'BackendServerDescriptionsRemote' => [],
            'Subnets' => options[:subnet_ids] || [],
            'Scheme' => options[:scheme].nil? ? 'internet-facing' : options[:scheme],
            'SecurityGroups' => options[:security_groups].nil? ? [] : options[:security_groups],
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
            'LoadBalancerAttributes' => {
              'ConnectionDraining' => {'Enabled' => false, 'Timeout' => 300},
              'CrossZoneLoadBalancing' => {'Enabled' => false}
            },
            'LoadBalancerName' => lb_name,
            'Policies' => {
              'AppCookieStickinessPolicies' => [],
              'LBCookieStickinessPolicies' => [],
              'OtherPolicies' => [],
              'Proper' => []
            },
            'SourceSecurityGroup' => {
              'GroupName' => security_group['groupName'],
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
