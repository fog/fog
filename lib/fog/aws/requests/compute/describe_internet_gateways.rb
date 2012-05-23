module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/describe_internet_gateways'

        # Describe all or specified internet_gateways
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'InternetGatewaySet'<~Array>:
        #   * 'internetGatewayId'<~String> - The ID of the Internet gateway. 
        #   * 'attachmentSet'<~Array>: - A list of VPCs attached to the Internet gateway
        #     * 'vpcId'<~String> - The ID of the VPC the Internet gateway is attached to
        #     * 'state'<~String> - The current state of the attachment
        # * 'tagSet'<~Array>: Tags assigned to the resource.
        #   * 'key'<~String> - Tag's key
        #   * 'value'<~String> - Tag's value
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-ItemType-InternetGatewayType.html]
        def describe_internet_gateways(filters = {})
          unless filters.is_a?(Hash)
            Fog::Logger.warning("describe_internet_gateways with #{filters.class} param is deprecated, use internet_gateways('internet-gateway-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'internet-gateway-id' => [*filters]}
          end
          params = Fog::AWS.indexed_filters(filters)
          request({
            'Action' => 'DescribeInternetGateways',
            :idempotent => true,
            :parser => Fog::Parsers::Compute::AWS::DescribeInternetGateways.new
          }.merge!(params))
        end
      end
      
      class Mock
        def describe_internet_gateways(filters = {})
          Excon::Response.new.tap do |response|
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'internetGatewaySet'    => [
                'internetGatewayId'      => Fog::AWS::Mock.request_id,
                'attachmentSet'          => {
                  'vpcId'                  => Fog::AWS::Mock.request_id,
                  'state'                  => 'pending',
                },
                'tagSet'                 =>  {}
              ]
            }
          end
        end
      end
    end
  end
end
