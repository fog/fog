module Fog
  module AWS
    class EC2

      # Describe all or specified instances
      #
      # ==== Parameters
      # * instance_id<~Array> - List of instance ids to describe, defaults to all
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      def describe_instances(instance_id = [])
        params = indexed_params('InstanceId', instance_id)
        request({
          'Action' => 'DescribeInstances',
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeInstances.new)
      end

    end
  end
end
