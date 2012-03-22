module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/create_network_interface'

        # Creates a network interface
        #
        # ==== Parameters
        # * subnetId<~String> - The ID of the subnet to associate with the network interface
        # * options<~Hash>:
        #   * PrivateIpAddress<~String> - The private IP address of the network interface
        #   * Description<~String>      - The description of the network interface
        #   * groupSet<~Array>          - The security group IDs for use by the network interface
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String>          - Id of request
        # * 'networkInterface'<~Hash>     - The created network interface
        # *   'networkInterfaceId'<~String> - The ID of the network interface
        # *   'subnetId'<~String>           - The ID of the subnet
        # *   'vpcId'<~String>              - The ID of the VPC
        # *   'availabilityZone'<~String>   - The availability zone
        # *   'description'<~String>        - The description
        # *   'ownerId'<~String>            - The ID of the person who created the interface
        # *   'requesterId'<~String>        - The ID ot teh entity requesting this interface
        # *   'requesterManaged'<~String>   - 
        # *   'status'<~String>             - "available" or "in-use"
        # *   'macAddress'<~String>         - 
        # *   'privateIpAddress'<~String>   - IP address of the interface within the subnet
        # *   'privateDnsName'<~String>     - The private DNS name
        # *   'sourceDestCheck'<~Boolean>   - Flag indicating whether traffic to or from the instance is validated
        # *   'groupSet'<~Hash>             - Associated security groups
        # *     'key'<~String>              - ID of associated group
        # *     'value'<~String>            - Name of associated group
        # *   'attachment'<~Hash>:          - Describes the way this nic is attached
        # *     'attachmentID'<~String>
        # *     'instanceID'<~String>
        # *   'association'<~Hash>:         - Describes an eventual instance association
        # *     'attachmentID'<~String>     - ID of the network interface attachment
        # *     'instanceID'<~String>       - ID of the instance attached to the network interface
        # *     'publicIp'<~String>         - Address of the Elastic IP address bound to the network interface
        # *     'ipOwnerId'<~String>        - ID of the Elastic IP address owner
        # *   'tagSet'<~Array>:             - Tags assigned to the resource.
        # *     'key'<~String>              - Tag's key
        # *     'value'<~String>            - Tag's value
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/2012-03-01/APIReference/ApiReference-query-CreateNetworkInterface.html]
        def create_network_interface(subnetId, options = {})
          if security_groups = options.delete('GroupSet')
            options.merge!(Fog::AWS.indexed_param('SecurityGroupId', [*security_groups]))
          end
          request({
            'Action'     => 'CreateNetworkInterface',
            'SubnetId'   => subnetId,
            :parser      => Fog::Parsers::Compute::AWS::CreateNetworkInterface.new
          }.merge!(options))

        end
      end
      
      class Mock
        def create_network_interface(subnetId, options = {})
          response = Excon::Response.new
          if subnetId
            id = Fog::AWS::Mock.network_interface_id

            groups = {}
            if options['GroupSet']
              options['GroupSet'].each do |group_id|
                name = self.data[:security_groups].select { |k,v| v['groupId'] == group_id } .first.first
                if name.nil?
                  raise Fog::Compute::AWS::Error.new("Unknown security group '#{group_id}' specified")
                end
                groups[group_id] = name
              end
            end
            if options['PrivateIpAddress'].nil?
              options['PrivateIpAddress'] = "10.0.0.2"
            end

            data = {
              'networkInterfaceId' => id,
              'subnetId'           => subnetId,
              'vpcId'              => 'mock-vpc-id',
              'availabilityZone'   => 'mock-zone',
              'description'        => options['Description'],
              'ownerId'            => '',
              'requesterManaged'   => 'false',
              'status'             => 'available',
              'macAddress'         => '00:11:22:33:44:55',
              'privateIpAddress'   => options['PrivateIpAddress'],
              'sourceDestCheck'    => true,
              'groupSet'           => groups,
              'attachment'         => {},
              'association'        => {},
              'tagSet'             => {}
            }
            self.data[:network_interfaces][id] = data
            response.body = {
              'requestId'        => Fog::AWS::Mock.request_id,
              'networkInterface' => data
            }
            response
          else
            response.status = 400
            response.body = {
              'Code'    => 'InvalidParameterValue',
              'Message' => "Invalid value '' for subnetId"
            }
          end
        end
      end
    end
  end
end
