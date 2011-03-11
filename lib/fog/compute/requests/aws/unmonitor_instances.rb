module Fog
  module AWS
    class Compute

      class Real

        require 'fog/compute/parsers/aws/monitor_unmonitor_instances'

        # UnMonitor specified instance
        # http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-UnmonitorInstances.html
        #
        # ==== Parameters
        # * instance_ids<~Array> - Arrays of instances Ids to monitor
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'instancesSet': http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-ItemType-MonitorInstancesResponseSetItemType.html
        def unmonitor_instances(instance_ids)
          params = AWS.indexed_param('InstanceId', instance_ids)
          request({
                          'Action' => 'UnmonitorInstances',
                          :idempotent => true,
                          :parser => Fog::Parsers::AWS::Compute::MonitorUnmonitorInstances.new
                  }.merge!(params))
        end

      end

      class Mock

        def unmonitor_instances(instance_ids)
          response        = Excon::Response.new
          response.status = 200
          response.body   = instance_ids.inject({}) { |memo, id| {memo[id] => 'disabled'} }
        end

      end

    end

  end
end
