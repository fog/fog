unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Terminate specified instances
        #
        # ==== Parameters
        # * instance_id<~Array> - Ids of instances to terminates
        #
        # ==== Returns
        # # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'instancesSet'<~Array>:
        #       * 'instanceId'<~String> - id of the terminated instance
        #       * 'previousState'<~Hash>: previous state of instance
        #         * 'code'<~Integer> - previous status code
        #         * 'name'<~String> - name of previous state
        #       * 'shutdownState'<~Hash>: shutdown state of instance
        #         * 'code'<~Integer> - current status code
        #         * 'name'<~String> - name of current state
        def terminate_instances(instance_id)
          params = indexed_params('InstanceId', instance_id)
          request({
            'Action' => 'TerminateInstances'
          }.merge!(params), Fog::Parsers::AWS::EC2::TerminateInstances.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def terminate_instances(instance_id)
          response = Fog::Response.new
          instance_id = [*instance_id]
          if (Fog::AWS::EC2.data[:instances].keys & instance_id).length == instance_id.length
            for instance_id in instance_id
              response.body = {
                'requestId'     => Fog::AWS::Mock.request_id,
                'instancesSet'  => []
              }
              instance = Fog::AWS::EC2.data[:instances][instance_id]
              Fog::AWS::EC2.data[:deleted_at][instance_id] = Time.now
              instance['status'] = 'deleting'
              response.status = 200
              # TODO: the codes are mostly educated guessing, not certainty
              code = case instance['state']
              when 'pending'
                0
              when 'running'
                16
              when 'shutting-down'
                32
              when 'terminated'
                64
              when 'rebooting'
                128
              end
              response.body['instancesSet'] << {
                'instanceId'    => instance_id,
                'previousState' => { 'name' => instance['state'], 'code' => code },
                'shutdownState' => { 'name' => 'shutting-down', 'code' => 32}
              }
            end
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
