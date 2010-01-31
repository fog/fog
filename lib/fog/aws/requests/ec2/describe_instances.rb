unless Fog.mocking?

  module Fog
    module AWS
      class EC2

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
        #           * 'amiLaunchIndex'<~Integer> - reference to instance in launch group
        #           * 'dnsName'<~String> - public dns name, blank until instance is running
        #           * 'imageId'<~String> - image id of ami used to launch instance
        #           * 'instanceId'<~String> - id of the instance
        #           * 'instanceState'<~Hash>:
        #             * 'code'<~Integer> - current status code
        #             * 'name'<~String> - current status name
        #           * 'instanceType'<~String> - type of instance
        #           * 'kernelId'<~String> - Id of kernel used to launch instance
        #           * 'keyName'<~String> - name of key used launch instances or blank
        #           * 'launchTime'<~Time> - time instance was launched
        #           * 'monitoring'<~Hash>:
        #             * 'state'<~Boolean - state of monitoring
        #           * 'placement'<~Hash>:
        #             * 'availabilityZone'<~String> - Availability zone of the instance
        #           * 'productCodes'<~Array> - Product codes for the instance
        #           * 'privateDnsName'<~String> - private dns name, blank until instance is running
        #           * 'ramdiskId'<~String> - Id of ramdisk used to launch instance
        #           * 'reason'<~String> - reason for most recent state transition, or blank
        def describe_instances(instance_id = [])
          params = AWS.indexed_param('InstanceId', instance_id)
          request({
            'Action' => 'DescribeInstances'
          }.merge!(params), Fog::Parsers::AWS::EC2::DescribeInstances.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def describe_instances(instance_id = {})
          response = Excon::Response.new
          instance_id = [*instance_id]
          if instance_id != []
            instance_set = Fog::AWS::EC2.data[:instances].reject {|key,value| !instance_id.include?(key)}.values
          else
            instance_set = Fog::AWS::EC2.data[:instances].values
          end

          instance_set.each do |instance|
            case instance['instanceState']
            when 'pending'
              if Time.now - instance['launchTime'] > 2
                instance['instanceState'] = { :code => 16, :name => 'running' }
              end
            when 'rebooting'
              instance['instanceState'] = { :code => 16, :name => 'running' }
            when 'shutting-down'
              if Time.now - Fog::AWS::EC2.data[:deleted_at][instance['instanceId']] > 2
                instance['instanceState'] = { :code => 16, :name => 'terminating' }
              end
            when 'terminating'
              if Time.now - Fog::AWS::EC2.data[:deleted_at][instance['instanceId']] > 4
                Fog::AWS::EC2.data[:deleted_at].delete(instance['instanceId'])
                Fog::AWS::EC2.data[:instances].delete(instance['instanceId'])
              end
            end
          end

          if instance_id.length == 0 || instance_id.length == instance_set.length
            response.status = 200

            reservation_set = {}
            instance_set.each do |instance|
              reservation_set[instance['reservationId']] ||= {
                'groupSet'      => instance['groupSet'],
                'instancesSet'  => [],
                'ownerId'       => instance['ownerId'],
                'reservationId' => instance['reservationId']
              }
              reservation_set[instance['reservationId']]['instancesSet'] << instance.reject{|key,value| !['amiLaunchIndex', 'dnsName', 'imageId', 'instanceId', 'instanceState', 'instanceType', 'kernelId', 'keyName', 'launchTime', 'monitoring', 'placement', 'privateDnsName', 'productCodes', 'ramdiskId', 'reason'].include?(key)}
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
