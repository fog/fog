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
