unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Disassociate an elastic IP address from its instance (if any)
        #
        # ==== Parameters
        # * public_ip<~String> - Public ip to assign to instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def disassociate_address(public_ip)
          request({
            'Action' => 'DisassociateAddress',
            'PublicIp' => public_ip
          }, Fog::Parsers::AWS::EC2::Basic.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def disassociate_address(public_ip)
          response = Fog::Response.new
          response.status = 200
          if address = Fog::AWS::EC2.data[:addresses][public_ip]
            address['instanceId'] = ''
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
