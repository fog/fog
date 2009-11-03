unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Associate an elastic IP address with an instance
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to associate address with
        # * public_ip<~String> - Public ip to assign to instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def associate_address(instance_id, public_ip)
          request({
            'Action' => 'AssociateAddress',
            'InstanceId' => instance_id,
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

        def associate_address(instance_id, public_ip)
          response = Fog::Response.new
          response.status = 200
          instance = Fog::AWS::EC2.data[:instances][instance_id]
          address = Fog::AWS::EC2.data[:addresses][public_ip]
          if instance && address
            address['instanceId'] = instance_id
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
