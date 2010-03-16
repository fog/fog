unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Release an elastic IP address.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def release_address(public_ip)
          request(
            'Action'    => 'ReleaseAddress',
            'PublicIp'  => public_ip,
            :parser     => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def release_address(public_ip)
          response = Excon::Response.new
          if (address = Fog::AWS::EC2.data[:addresses].delete(public_ip))
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end

end
