module Fog
  module AWS
    class EC2

      class Server < Fog::Model

        identity  :id,                'instanceId'

        attribute :ami_launch_index,  'amiLaunchIndex'
        attribute :availability_zone, 'availabilityZone'
        attribute :dns_name,          'dnsName'
        attribute :group_id,          'groupId'
        attribute :image_id,          'imageId'
        attribute :state,             'instanceState'
        attribute :type,              'instanceType'
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
          requires :id

          connection.addresses(:server => self)
        end

        def destroy
          requires :id

          connection.terminate_instances(@id)
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
          requires :key_name

          connection.keypairs.all(@key_name).first
        end

        def key_pair=(new_keypair)
          @key_name = new_keypair.name
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

        def reboot
          requires :id

          connection.reboot_instances(@id)
          true
        end

        def save
          requires :image_id

          options = {}
          if @availability_zone
            options['Placement.AvailabilityZone'] = @availability_zone
          end
          if @group_id
            options['SecurityGroup'] = @group_id
          end
          if @type
            options['InstanceType'] = @type
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
          requires :id

          connection.volumes(:server => self)
        end

        private

        def state=(new_state)
          if new_state.is_a?(Hash)
            @state = new_state['name']
          else
            @state = new_state
          end
        end

      end

    end
  end
end
