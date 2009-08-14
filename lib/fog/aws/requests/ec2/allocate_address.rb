unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Acquire an elastic IP address.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'publicIp'<~String> - The acquired address
        #     * 'requestId'<~String> - Id of the request
        def allocate_address
          request({
            'Action' => 'AllocateAddress'
          }, Fog::Parsers::AWS::EC2::AllocateAddress.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def allocate_address
          response = Fog::Response.new
          response.status = 200
          data ={
            'publicIp' => Fog::AWS::Mock.ip_address
          }
          @data[:addresses] << data
          response.body = {
            'publicIp'  => data['publicIp'],
            'requestId' => Fog::AWS::Mock.request_id
          }
          response
        end

      end
    end
  end

end
