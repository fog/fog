module Fog
  module AWS
    module EC2
      class Real

        require 'fog/aws/parsers/ec2/basic'

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
          request(
            'Action'      => 'AssociateAddress',
            'InstanceId'  => instance_id,
            'PublicIp'    => public_ip,
            :parser       => Fog::Parsers::AWS::EC2::Basic.new
          )
        end

      end

      class Mock

        def associate_address(instance_id, public_ip)
          response = Excon::Response.new
          response.status = 200
          instance = @data[:instances][instance_id]
          address = @data[:addresses][public_ip]
          if instance && address
            address['instanceId'] = instance_id
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
