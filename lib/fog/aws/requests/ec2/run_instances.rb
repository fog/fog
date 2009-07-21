module Fog
  module AWS
    class EC2

      # Launch specified instances
      #
      # ==== Parameters
      # * image_id<~String> - Id of machine image to load on instances
      # * min_count<~Integer> - Minimum number of instances to launch. If this
      #   exceeds the count of available instances, no instances will be 
      #   launched.  Must be between 1 and maximum allowed for your account
      #   (by default the maximum for an account is 20)
      # * max_count<~Integer> - Maximum number of instances to launch. If this
      #   exceeds the number of available instances, the largest possible
      #   number of instances above min_count will be launched instead. Must 
      #   be between 1 and maximum allowed for you account
      #   (by default the maximum for an account is 20)
      # * options<~Hash>:
      #   * :availability_zone<~String> - Placement constraint for instances
      #   * :data<~String> -  Additional data to provide to booting instances
      #   * :device_name<~String> - ?
      #   * :encoding<~String> - ?
      #   * :group_id<~String> - Name of security group for instances
      #   * :instance_type<~String> - Type of instance to boot. Valid options
      #     in ['m1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge']
      #     default is 'm1.small'
      #   * :kernel_id<~String> - Id of kernel with which to launch
      #   * :key_name<~String> - Name of a keypair to add to booting instances
      #   * :monitoring_enabled<~Boolean> - Enables monitoring, defaults to 
      #     disabled
      #   * :ramdisk_id<~String> - Id of ramdisk with which to launch
      #   * :version<~String> - ?
      #   * :virtual_name<~String> - ?
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :group_set<~Array>: groups the instances are members in
      #       * group_name<~String> - Name of group
      #     * :instances_set<~Array>: returned instances
      #       * instance<~Hash>:
      #         * :ami_launch_index<~Integer> - reference to instance in launch group
      #         * :dns_name<~String> - public dns name, blank until instance is running
      #         * :image_id<~String> - image id of ami used to launch instance
      #         * :instance_id<~String> - id of the instance
      #         * :instance_state<~Hash>:
      #           * :code<~Integer> - current status code
      #           * :name<~String> - current status name
      #         * :instance_type<~String> - type of instance
      #         * :kernel_id<~String> - Id of kernel used to launch instance
      #         * :key_name<~String> - name of key used launch instances or blank
      #         * :launch_time<~Time> - time instance was launched
      #         * :monitoring<~Hash>:
      #           * :state<~Boolean - state of monitoring
      #         * :placement<~Hash>:
      #           * :availability_zone<~String> - Availability zone of the instance
      #         * :private_dns_name<~String> - private dns name, blank until instance is running
      #         * :product_codes<~Array> - Product codes for the instance
      #         * :ramdisk_id<~String> - Id of ramdisk used to launch instance
      #         * :reason<~String> - reason for most recent state transition, or blank
      #     * :owner_id<~String> - Id of owner
      #     * :request_id<~String> - Id of request
      def run_instances(image_id, min_count, max_count, options = {})
        request({
          'Action' => 'RunInstances',
          'ImageId' => image_id,
          'MinCount' => min_count,
          'MaxCount' => max_count,
          'AvailabilityZone' => options[:availability_zone],
          'Data' => options[:data],
          'DeviceName' => options[:device_name],
          'Encoding' => options[:encoding],
          'GroupId' => options[:group_id],
          'InstanceType' => options[:instance_type],
          'KernelId' => options[:kernel_id],
          'KeyName' => options[:key_name],
          'Monitoring.Enabled' => options[:monitoring_enabled].nil? ? nil : "#{options[:monitoring_enabled]}",
          'RamdiskId' => options[:ramdisk_id],
          'Version' => options[:version],
          'VirtualName' => options[:virtual_name]
        }, Fog::Parsers::AWS::EC2::RunInstances.new)
      end

    end
  end
end
