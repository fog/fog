module Fog
  module AWS
    class EC2

      # Retrieve console output for specified instance
      #
      # ==== Parameters
      # * instance_id<~String> - Id of instance to get console output from
      #
      # ==== Returns
      # # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'instanceId'<~String> - Id of instance
      #     * 'output'<~String> - Console output
      #     * 'requestId'<~String> - Id of request
      #     * 'timestamp'<~Time> - Timestamp of last update to output
      def get_console_output(instance_id)
        request({
          'Action' => 'GetConsoleOutput',
          'InstanceId' => instance_id
        }, Fog::Parsers::AWS::EC2::GetConsoleOutput.new)
      end

    end
  end
end
