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
      #     * :reservation_set<~Array>:
      #       * :group_set<~Array> - Group names for reservation
      #       * :owner_id<~String> - AWS Access Key ID of reservation owner
      #       * :reservation_id<~String> - Id of the reservation
      #       * :instances_set<~Array>:
      #         * instance<~Hash>:
      #           * :ami_launch_index<~Integer> - reference to instance in launch group
      #           * :dns_name<~String> - public dns name, blank until instance is running
      #           * :image_id<~String> - image id of ami used to launch instance
      #           * :instance_id<~String> - id of the instance
      #           * :instance_state<~Hash>:
      #             * :code<~Integer> - current status code
      #             * :name<~String> - current status name
      #           * :instance_type<~String> - type of instance
      #           * :kernel_id<~String> - Id of kernel used to launch instance
      #           * :key_name<~String> - name of key used launch instances or blank
      #           * :launch_time<~Time> - time instance was launched
      #           * :monitoring<~Hash>:
      #             * :state<~Boolean - state of monitoring
      #           * :placement<~Hash>:
      #             * :availability_zone<~String> - Availability zone of the instance
      #           * :product_codes<~Array> - Product codes for the instance
      #           * :private_dns_name<~String> - private dns name, blank until instance is running
      #           * :ramdisk_id<~String> - Id of ramdisk used to launch instance
      #           * :reason<~String> - reason for most recent state transition, or blank
      def describe_instances(instance_id = [])
        params = indexed_params('InstanceId', instance_id)
        request({
          'Action' => 'DescribeInstances',
        }.merge!(params), Fog::Parsers::AWS::EC2::DescribeInstances.new)
      end

    end
  end
end
