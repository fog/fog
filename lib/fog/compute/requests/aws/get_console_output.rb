module Fog
  module Compute
    class AWS
      class Real

        require 'fog/compute/parsers/aws/get_console_output'

        # Retrieve console output for specified instance
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to get console output from
        #
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'instanceId'<~String> - Id of instance
        #     * 'output'<~String> - Console output
        #     * 'requestId'<~String> - Id of request
        #     * 'timestamp'<~Time> - Timestamp of last update to output
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-GetConsoleOutput.html]
        def get_console_output(instance_id)
          request(
            'Action'      => 'GetConsoleOutput',
            'InstanceId'  => instance_id,
            :idempotent   => true,
            :parser       => Fog::Parsers::Compute::AWS::GetConsoleOutput.new
          )
        end

      end

      class Mock

        def get_console_output(instance_id)
          response = Excon::Response.new
          if instance = self.data[:instances][instance_id]
            response.status = 200
            response.body = {
              'instanceId'    => instance_id,
              'output'        => (Time.now - instance['launchTime'] >= Fog::Mock.delay) ? nil : Fog::AWS::Mock.console_output,
              'requestId'     => Fog::AWS::Mock.request_id,
              'timestamp'     => Time.now
            }
            response
          else;
            raise Fog::Compute::AWS::NotFound.new("The instance ID '#{instance_id}' does not exist")
          end
        end

      end
    end
  end
end
