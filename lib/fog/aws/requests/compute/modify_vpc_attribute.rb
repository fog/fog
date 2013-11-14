module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Modifies the specified attribute of the specified VPC.
        #
        # ==== Parameters
        # * vpc_id<~String> - The ID of the VPC.
        # * options<~Hash>:
        #   * enableDnsSupport<~Boolean> - Indicates whether DNS resolution is supported for the VPC. If this attribute is true, the Amazon DNS
        #     server resolves DNS hostnames for your instances to their corresponding IP addresses; otherwise, it does not.
        #   * enableDnsHostnames<~Boolean> - Indicates whether the instances launched in the VPC get DNS hostnames. If this attribute is true, 
        #     instances in the VPC get DNS hostnames; otherwise, they do not. You can only set enableDnsHostnames to true if you also set the 
        #     EnableDnsSupport attribute to true.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-ModifyVpcAttribute.html]
        def modify_vpc_attribute(vpc_id, options = {})
          request({
            'Action'             => 'ModifyVpcAttribute',
            'VpcId'              => vpc_id,
            :idempotent          => true,
            :parser              => Fog::Parsers::Compute::AWS::Basic.new
          }.merge!(options))
        end

      end

      class Mock

        def modify_vpc_attribute(vpc_id, options = {})
          response = Excon::Response.new
          if options.size == 0
            raise Fog::Compute::AWS::Error.new("InvalidParameterCombination => No attributes specified.")
          elsif options.size > 1
            raise Fog::Compute::AWS::Error.new("InvalidParameterCombination =>  InvalidParameterCombination => Fields for multiple attribute types specified: #{options.keys.join(', ')}")
          elsif self.data[:vpcs].select{|x| x['vpcId'] == vpc_id}.size
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The vpc '#{vpc_id}' does not exist.")
          end
        end
      end
    end
  end
end
