unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Reboot specified instances
        #
        # ==== Parameters
        # * instance_id<~Array> - Ids of instances to reboot
        #
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        def reboot_instances(instance_id = [])
          params = AWS.indexed_param('InstanceId', instance_id)
          request({
            'Action'  => 'RebootInstances',
            :parser   => Fog::Parsers::AWS::EC2::Basic.new
          }.merge!(params))
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def reboot_instances(instance_id = [])
          response = Excon::Response.new
          instance_id = [*instance_id]
          if (Fog::AWS::EC2.data[:instances].keys & instance_id).length == instance_id.length
            for instance_id in instance_id
              Fog::AWS::EC2.data[:instances][instance_id]['status'] = 'rebooting'
            end
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
