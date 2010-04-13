module Fog
  module AWS
    module EC2
      class Real

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
        def get_console_output(instance_id)
          request(
            'Action'      => 'GetConsoleOutput',
            'InstanceId'  => instance_id,
            :parser       => Fog::Parsers::AWS::EC2::GetConsoleOutput.new
          )
        end

      end

      class Mock

        def get_console_output(instance_id)
          response = Excon::Response.new
          if instance = @data[:instances][instance_id]
            response.status = 200
            response.body = {
              'instanceId'    => instance_id,
              'output'        => Fog::AWS::Mock.console_output,
              'requestId'     => Fog::AWS::Mock.request_id,
              'timestamp'     => Time.now
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
