module Fog
  module AWS
    module EC2
      class Real

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
          request(
            'Action'    => 'DisassociateAddress',
            'PublicIp'  => public_ip,
            :parser     => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end

      class Mock

        def disassociate_address(public_ip)
          response = Excon::Response.new
          response.status = 200
          if address = @data[:addresses][public_ip]
            address['instanceId'] = nil
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
