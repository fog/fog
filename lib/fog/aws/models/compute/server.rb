require 'fog/compute/models/server'

module Fog
  module Compute
    class AWS

      class Server < Fog::Compute::Server
        extend Fog::Deprecation
        deprecate :ip_address, :public_ip_address

        identity  :id,                    :aliases => 'instanceId'

        attr_accessor :architecture
        attribute :ami_launch_index,      :aliases => 'amiLaunchIndex'
        attribute :availability_zone,     :aliases => 'availabilityZone'
        attribute :block_device_mapping,  :aliases => 'blockDeviceMapping'
        attribute :client_token,          :aliases => 'clientToken'
        attribute :dns_name,              :aliases => 'dnsName'
        attribute :groups
        attribute :flavor_id,             :aliases => 'instanceType'
        attribute :image_id,              :aliases => 'imageId'
        attr_accessor :instance_initiated_shutdown_behavior
        attribute :kernel_id,             :aliases => 'kernelId'
        attribute :key_name,              :aliases => 'keyName'
        attribute :created_at,            :aliases => 'launchTime'
        attribute :monitoring,            :squash => 'state'
        attribute :placement_group,       :aliases => 'groupName'
        attribute :platform,              :aliases => 'platform'
        attribute :product_codes,         :aliases => 'productCodes'
        attribute :private_dns_name,      :aliases => 'privateDnsName'
        attribute :private_ip_address,    :aliases => 'privateIpAddress'
        attribute :public_ip_address,     :aliases => 'ipAddress'
        attribute :ramdisk_id,            :aliases => 'ramdiskId'
        attribute :reason
        attribute :root_device_name,      :aliases => 'rootDeviceName'
        attribute :root_device_type,      :aliases => 'rootDeviceType'
        attribute :state,                 :aliases => 'instanceState', :squash => 'name'
        attribute :state_reason,          :aliases => 'stateReason'
        attribute :subnet_id,             :aliases => 'subnetId'
        attribute :tenancy
        attribute :tags,                  :aliases => 'tagSet'
        attribute :user_data

        attr_accessor :password
        attr_writer   :private_key, :private_key_path, :public_key, :public_key_path, :username

        def initialize(attributes={})
          self.groups     ||= ["default"] unless attributes[:subnet_id]
          self.flavor_id  ||= 't1.micro'
          self.image_id   ||= begin
            self.username = 'ubuntu'
            case attributes[:connection].instance_variable_get(:@region) # Ubuntu 10.04 LTS 64bit (EBS)
            when 'ap-northeast-1'
              'ami-5e0fa45f'
            when 'ap-southeast-1'
              'ami-f092eca2'
            when 'eu-west-1'
              'ami-3d1f2b49'
            when 'us-east-1'
              'ami-3202f25b'
            when 'us-west-1'
              'ami-f5bfefb0'
            end
          end
          super
        end

        def addresses
          requires :id

          connection.addresses(:server => self)
        end

        def console_output
          requires :id

          connection.get_console_output(id)
        end

        def destroy
          requires :id

          connection.terminate_instances(id)
          true
        end

        remove_method :flavor_id
        def flavor_id
          @flavor && @flavor.id || attributes[:flavor_id]
        end

        def flavor=(new_flavor)
          @flavor = new_flavor
        end

        def flavor
          @flavor ||= connection.flavors.all.detect {|flavor| flavor.id == flavor_id}
        end

        def key_pair
          requires :key_name

          connection.key_pairs.all(key_name).first
        end

        def key_pair=(new_keypair)
          self.key_name = new_keypair && new_keypair.name
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def ready?
          state == 'running'
        end

        def reboot
          requires :id
          connection.reboot_instances(id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :image_id

          options = {
            'BlockDeviceMapping'          => block_device_mapping,
            'ClientToken'                 => client_token,
            'InstanceInitiatedShutdownBehavior' => instance_initiated_shutdown_behavior,
            'InstanceType'                => flavor_id,
            'KernelId'                    => kernel_id,
            'KeyName'                     => key_name,
            'Monitoring.Enabled'          => monitoring,
            'Placement.AvailabilityZone'  => availability_zone,
            'Placement.GroupName'         => placement_group,
            'Placement.Tenancy'           => tenancy,
            'RamdiskId'                   => ramdisk_id,
            'SecurityGroup'               => groups,
            'SubnetId'                    => subnet_id,
            'UserData'                    => user_data
          }
          options.delete_if {|key, value| value.nil?}

          # If subnet is defined we are working on a virtual private cloud.
          # subnet & security group cannot co-exist. I wish VPC just ignored
          # the security group parameter instead, it would be much easier!
          if subnet_id
            options.delete('SecurityGroup')
          else
            options.delete('SubnetId')
          end

          data = connection.run_instances(image_id, 1, 1, options)
          merge_attributes(data.body['instancesSet'].first)

          if tags = self.tags
            # expect eventual consistency
            Fog.wait_for { self.reload rescue nil }
            for key, value in (self.tags = tags)
              connection.tags.create(
                :key          => key,
                :resource_id  => self.identity,
                :value        => value
              )
            end
          end

          true
        end

        def setup(credentials = {})
          requires :public_ip_address, :username
          require 'multi_json'
          require 'net/ssh'

          commands = [
            %{mkdir .ssh},
            %{passwd -l #{username}},
            %{echo "#{MultiJson.encode(Fog::JSON.sanitize(attributes))}" >> ~/attributes.json}
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          # wait for aws to be ready
          Timeout::timeout(360) do
            begin
              Timeout::timeout(8) do
                Fog::SSH.new(public_ip_address, username, credentials.merge(:timeout => 4)).run('pwd')
              end
            rescue Errno::ECONNREFUSED
              sleep(2)
              retry
            rescue Net::SSH::AuthenticationFailed, Timeout::Error
              retry
            end
          end
          Fog::SSH.new(public_ip_address, username, credentials).run(commands)
        end

        def start
          requires :id
          connection.start_instances(id)
          true
        end

        def stop(force = false)
          requires :id
          connection.stop_instances(id, force)
          true
        end

        def username
          @username ||= 'root'
        end

        def volumes
          requires :id
          connection.volumes(:server => self)
        end

        #I tried to call it monitoring= and be smart with attributes[]
        #but in #save a merge_attribute is called after run_instance
        #thus making an un-necessary request. Use this until finding a clever solution
        def monitor=(new_monitor)
          if identity
            case new_monitor
            when true
              response = connection.monitor_instances(identity)
            when false
              response = connection.unmonitor_instances(identity)
            else
              raise ArgumentError.new("only Boolean allowed here")
            end
          end
          self.monitoring = new_monitor
        end

        private

        def placement=(new_placement)
          if new_placement.is_a?(Hash)
            merge_attributes(new_placement)
          else
            self.attributes[:placement] = new_placement
          end
        end

      end

    end
  end
end
