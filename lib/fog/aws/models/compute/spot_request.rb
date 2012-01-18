require 'fog/core/model'

module Fog
  module Compute
    class AWS
      
      class SpotRequest < Fog::Model

        identity :id,                          :aliases => 'spotInstanceRequestId'

        attribute :price,                      :aliases => 'spotPrice'
        attribute :request_type,               :aliases => 'type'
        attribute :created_at,                 :aliases => 'createTime'
        attribute :instance_count,             :aliases => 'instanceCount'
        attribute :instance_id,                :aliases => 'instanceId'
        attribute :state

        attribute :valid_from,                 :aliases => 'validFrom'
        attribute :valid_until,                :aliases => 'validUntil'
        attribute :launch_group,               :aliases => 'launchGroup'
        attribute :availability_zone_group,    :aliases => 'availabilityZoneGroup'
        attribute :product_description,        :aliases => 'productDescription'

        attribute :groups,                     :aliases => 'LaunchSpecification.SecurityGroup'
        attribute :key_name,                   :aliases => 'LaunchSpecification.KeyName'
        attribute :availability_zone,          :aliases => 'LaunchSpecification.Placement.AvailabilityZone'
        attribute :flavor_id,                  :aliases => 'LaunchSpecification.InstanceType'
        attribute :image_id,                   :aliases => 'LaunchSpecification.ImageId'
        attribute :monitoring,                 :aliases => 'LaunchSpecification.Monitoring'
        attribute :block_device_mapping,       :aliases => 'LaunchSpecification.BlockDeviceMapping'
        attribute :tags,                       :aliases => 'tagSet'
        attribute :fault,                      :squash  => 'message'
        attribute :user_data

        attr_writer :username

        def initialize(attributes={})
          self.groups ||= ["default"]
          self.flavor_id ||= 't1.micro'
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

        def destroy
          requires :id

          connection.cancel_spot_instance_requests(id)
          true
        end

        def key_pair
          requires :key_name

          connection.key_pairs.all(key_name).first
        end

        def key_pair=(new_keypair)
          self.key_name = new_keypair && new_keypair.name
        end

        def ready?
          state == 'active'
        end

        def save
          requires :image_id, :flavor_id, :price

          options = {
            'AvailabilityZoneGroup'                          => availability_zone_group,
            'InstanceCount'                                  => instance_count,
            'LaunchGroup'                                    => launch_group,
            'LaunchSpecification.BlockDeviceMapping'         => block_device_mapping,
            'LaunchSpecification.KeyName'                    => key_name,
            'LaunchSpecification.Monitoring.Enabled'         => monitoring,
            'LaunchSpecification.Placement.AvailabilityZone' => availability_zone,
            'LaunchSpecification.SecurityGroup'              => groups,
            'LaunchSpecification.UserData'                   => user_data,
            'Type'                                           => request_type,
            'ValidFrom'                                      => valid_from,
            'ValidUntil'                                     => valid_until }
          options.delete_if {|key, value| value.nil?}

          data = connection.request_spot_instances(image_id, flavor_id, price, options).body
          spot_instance_request = data['spotInstanceRequestSet'].first
          spot_instance_request['launchSpecification'].each do |name,value|
            spot_instance_request['LaunchSpecification.' + name[0,1].upcase + name[1..-1]] = value
          end
          spot_instance_request.merge(:groups => spot_instance_request['LaunchSpecification.GroupSet'])
          spot_instance_request.merge(options)
          merge_attributes( spot_instance_request )
        end

      end
    end
  end
end     
