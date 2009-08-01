module Fog
  module AWS
    class EC2

      # Reboot specified instances
      #
      # ==== Parameters
      # * instance_id<~Array> - Ids of instances to reboot
      #
      # ==== Returns
      # # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'requestId'<~String> - Id of request
      #     * 'return'<~Boolean> - success?
      def reboot_instances(instance_id = [])
        params = indexed_params('InstanceId', instance_id)
        request({
          'Action' => 'RebootInstances'
        }.merge!(params), Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
