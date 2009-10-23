module Fog
  module AWS
    class EC2

      class Instance < Fog::Model

        attribute :ami_launch_index,  'amiLaunchIndex'
        attribute :availability_zone, 'availabilityZone'
        attribute :dns_name,          'dnsName'
        attribute :group_id,          'groupId'
        attribute :image_id,          'imageId'
        attribute :instance_id,       'instanceId'
        attribute :instance_state,    'instanceState'
        attribute :instance_type,     'instanceType'
        attribute :kernel_id,         'kernelId'
        attribute :key_name,          'keyName'
        attribute :launch_time,       'launchTime'
        attribute :monitoring
        attribute :product_codes,     'productCodes'
        attribute :private_dns_name,  'privateDnsName'
        attribute :ramdisk_id,        'ramdiskId'
        attribute :reason
        attribute :user_data

        def addresses
          connection.addresses(:instance => self)
        end

        def destroy
          connection.terminate_instances(@instance_id)
          true
        end

        # def security_group
        #   connection.security_groups.all(@group_id)
        # end
        #
        # def security_group=(new_security_group)
        #   @group_id = new_security_group.name
        # end

        def key_pair
          connection.keypairs.all(@key_name).first
        end

        def key_pair=(new_keypair)
          @key_name = new_keypair.name
        end

        def instances
          @instances
        end

        def monitoring=(new_monitoring)
          if new_monitoring.is_a?(Hash)
            @monitoring = new_monitoring['state']
          else
            @monitoring = new_monitoring
          end
        end

        def placement=(new_placement)
          if new_placement.is_a?(Hash)
            @availability_zone = new_placement['availabilityZone']
          else
            @availability_zone = new_placement
          end
        end

        def reload
          if new_instance = instances.get(@instance_id)
            merge_attributes(new_instance.attributes)
          end
        end

        def save
          options = {}
          if @availability_zone
            options['Placement.AvailabilityZone'] = @availability_zone
          end
          if @group_id
            options['groupId'] = @group_id
          end
          if @instance_type
            options['InstanceType'] = @instance_type
          end
          if @kernel_id
            options['KernelId'] = @kernel_id
          end
          if @key_name
            options['KeyName'] = @key_name
          end
          if @monitoring
            options['Monitoring.Enabled'] = @monitoring
          end
          if @ramdisk_id
            options['RamdiskId'] = @ramdisk_id
          end
          if @user_data
            options['UserData'] = @user_data
          end
          data = connection.run_instances(@image_id, 1, 1, options)
          merge_attributes(data.body['instancesSet'].first)
          true
        end

        def volumes
          connection.volumes(:instance => self)
        end

        private

        def instance_state=(new_instance_state)
          @instance_state = new_instance_state['name']
        end

        def instances=(new_instances)
          @instances = new_instances
        end

      end

    end
  end
end
