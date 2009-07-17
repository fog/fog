module Fog
  module AWS
    class EC2

      # Launch specified instances
      #
      # ==== Parameters
      # * instance_id<~Array> - Ids of instances to terminates
      #
      # ==== Returns
      # FIXME: docs
      def terminate_instances(instance_id = [])
        params = indexed_params('InstanceId', instance_id)
        request({
          'Action' => 'TerminateInstances'
        }.merge!(params), Fog::Parsers::AWS::EC2::TerminateInstances.new)
      end

    end
  end
end
