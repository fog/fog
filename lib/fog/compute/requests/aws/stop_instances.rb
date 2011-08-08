module Fog
  module Compute
    class AWS
      class Real

        require 'fog/compute/parsers/aws/start_stop_instances'

        # Stop specified instance
        #
        # ==== Parameters
        # * instance_id<~Array> - Id of instance to start
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * TODO: fill in the blanks
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-StopInstances.html]
        def stop_instances(instance_id, force = false)
          params = Fog::AWS.indexed_param('InstanceId', instance_id)
          params.merge!('Force' => 'true') if force
          request({
            'Action'    => 'StopInstances',
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::StartStopInstances.new
          }.merge!(params))
        end

      end
    end
  end
end
