module Fog
  module AWS
    module EC2
      class Real

        # Describe all or specified instances
        #
        # ==== Parameters
        # * instance_id<~Array> - List of instance ids to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'reservationSet'<~Array>:
        #       * 'groupSet'<~Array> - Group names for reservation
        #       * 'ownerId'<~String> - AWS Access Key ID of reservation owner
        #       * 'reservationId'<~String> - Id of the reservation
        #       * 'instancesSet'<~Array>:
        #         * instance<~Hash>:
        #           * 'architecture'<~String> - architecture of image in [i386, x86_64]
        #           * 'amiLaunchIndex'<~Integer> - reference to instance in launch group
        #           * 'blockDeviceMapping'<~Array>
        #             * 'attachTime'<~Time> - time of volume attachment
        #             * 'deleteOnTermination'<~Boolean> - whether or not to delete volume on termination
        #             * 'deviceName'<~String> - specifies how volume is exposed to instance
        #             * 'status'<~String> - status of attached volume
        #             * 'volumeId'<~String> - Id of attached volume
        #           * 'dnsName'<~String> - public dns name, blank until instance is running
        #           * 'imageId'<~String> - image id of ami used to launch instance
        #           * 'instanceId'<~String> - id of the instance
        #           * 'instanceState'<~Hash>:
        #             * 'code'<~Integer> - current status code
        #             * 'name'<~String> - current status name
        #           * 'instanceType'<~String> - type of instance
        #           * 'ipAddress'<~String> - public ip address assigned to instance
        #           * 'kernelId'<~String> - id of kernel used to launch instance
        #           * 'keyName'<~String> - name of key used launch instances or blank
        #           * 'launchTime'<~Time> - time instance was launched
        #           * 'monitoring'<~Hash>:
        #             * 'state'<~Boolean - state of monitoring
        #           * 'placement'<~Hash>:
        #             * 'availabilityZone'<~String> - Availability zone of the instance
        #           * 'productCodes'<~Array> - Product codes for the instance
        #           * 'privateDnsName'<~String> - private dns name, blank until instance is running
        #           * 'privateIpAddress'<~String> - private ip address assigned to instance
        #           * 'rootDeviceName'<~String> - specifies how the root device is exposed to the instance
        #           * 'rootDeviceType'<~String> - root device type used by AMI in [ebs, instance-store]
        #           * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
        #           * 'reason'<~String> - reason for most recent state transition, or blank
        def describe_instances(instance_id = [])
          params = AWS.indexed_param('InstanceId', instance_id)
          request({
            'Action'  => 'DescribeInstances',
            :parser   => Fog::Parsers::AWS::EC2::DescribeInstances.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_instances(instance_id = [])
          response = Excon::Response.new
          instance_id = [*instance_id]
          if instance_id != []
            instance_set = @data[:instances].reject {|key,value| !instance_id.include?(key)}.values
          else
            instance_set = @data[:instances].values
          end

          if instance_id.length == 0 || instance_id.length == instance_set.length
            response.status = 200
            reservation_set = {}

            instance_set.each do |instance|
              case instance['instanceState']['name']
              when 'pending'
                if Time.now - instance['launchTime'] > Fog::Mock.delay
                  instance['ipAddress']         = Fog::AWS::Mock.ip_address
                  instance['dnsName']           = "ec2-#{instance['ipAddress'].gsub('.','-')}.compute-1.amazonaws.com"
                  instance['privateIpAddress']  = Fog::AWS::Mock.ip_address
                  instance['privateDnsName']    = "ip-#{instance['privateIpAddress'].gsub('.','-')}.ec2.internal"
                  instance['instanceState']     = { 'code' => 16, 'name' => 'running' }
                end
              when 'rebooting'
                instance['instanceState'] = { 'code' => 16, 'name' => 'running' }
              when 'shutting-down'
                if Time.now - @data[:deleted_at][instance['instanceId']] > Fog::Mock.delay * 2
                  @data[:deleted_at].delete(instance['instanceId'])
                  @data[:instances].delete(instance['instanceId'])
                elsif Time.now - @data[:deleted_at][instance['instanceId']] > Fog::Mock.delay
                  instance['instanceState'] = { 'code' => 16, 'name' => 'terminating' }
                end
              when 'terminating'
                if Time.now - @data[:deleted_at][instance['instanceId']] > Fog::Mock.delay
                  @data[:deleted_at].delete(instance['instanceId'])
                  @data[:instances].delete(instance['instanceId'])
                end
              end

              if @data[:instances][instance['instanceId']]
                reservation_set[instance['reservationId']] ||= {
                  'groupSet'      => instance['groupSet'],
                  'instancesSet'  => [],
                  'ownerId'       => instance['ownerId'],
                  'reservationId' => instance['reservationId']
                }
                reservation_set[instance['reservationId']]['instancesSet'] << instance.reject{|key,value| !['amiLaunchIndex', 'blockDeviceMapping', 'dnsName', 'imageId', 'instanceId', 'instanceState', 'instanceType', 'ipAddress', 'kernelId', 'keyName', 'launchTime', 'monitoring', 'placement', 'privateDnsName', 'privateIpAddress', 'productCodes', 'ramdiskId', 'reason', 'rootDeviceType'].include?(key)}
              end
            end

            response.body = {
              'requestId'       => Fog::AWS::Mock.request_id,
              'reservationSet' => reservation_set.values
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
