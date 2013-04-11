module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/disassociate_route_table'

        # Attach an Amazon EBS volume with a running instance, exposing as specified device
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to associate volume with
        # * volume_id<~String> - Id of amazon EBS volume to associate with instance
        # * device<~String> - Specifies how the device is exposed to the instance (e.g. "/dev/sdh")
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'attachTime'<~Time> - Time of attachment was initiated at
        #     * 'device'<~String> - Device as it is exposed to the instance
        #     * 'instanceId'<~String> - Id of instance for volume
        #     * 'requestId'<~String> - Id of request
        #     * 'status'<~String> - Status of volume
        #     * 'volumeId'<~String> - Reference to volume
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AttachVolume.html]
        def disassociate_route_table(association_id)
          request(
            'Action'        => 'DisassociateRouteTable',
            'AssociationId' => association_id,
            :parser         => Fog::Parsers::Compute::AWS::DisassociateRouteTable.new
          )
        end

      end

      class Mock
        
      end
    end
  end
end
