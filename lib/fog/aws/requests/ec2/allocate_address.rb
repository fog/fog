module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/allocate_address'

        # Acquire an elastic IP address.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'publicIp'<~String> - The acquired address
        #     * 'requestId'<~String> - Id of the request
        def allocate_address
          request(
            'Action'  => 'AllocateAddress',
            :parser   => Fog::Parsers::AWS::EC2::AllocateAddress.new
          )
        end

      end

      class Mock

        def allocate_address
          response = Excon::Response.new
          response.status = 200
          public_ip = Fog::AWS::Mock.ip_address
          data ={
            'instanceId' => '',
            'publicIp'   => public_ip
          }
          @data[:addresses][public_ip] = data
          response.body = {
            'publicIp'  => public_ip,
            'requestId' => Fog::AWS::Mock.request_id
          }
          response
        end

      end
    end
  end
end
