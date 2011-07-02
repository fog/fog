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
        attribute :state

        # TODO: not sure how to handle
        #attribute :fault
        attribute :valid_from,                 :aliases => 'validFrom'
        attribute :valid_until,                :aliases => 'validUntil'
        attribute :launch_group,               :aliases => 'launchGroup'
        attribute :availability_zone_group,    :aliases => 'availabilityZoneGroup'
        attribute :product_description,        :aliases => 'productDescription'

        attribute :groups,                     :aliases => 'LaunchSpecification.SecurityGroup'
        attribute :key_name,                   :aliases => 'LaunchSpecification.KeyName'
        attribute :availability_zone,          :aliases => 'launchedAvailabilityZone'
        attribute :flavor_id,                  :aliases => 'LaunchSpecification.InstanceType'
        attribute :image_id,                   :aliases => 'LaunchSpecification.ImageId'
        attribute :monitoring,                 :aliases => 'LaunchSpecification.Monitoring'

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
          self.instance_count ||= 1
          super
        end

#        def destroy
#          requires :name

#          connection.delete_spot_request(name)
#          true
#        end

        def save
          requires :image_id, :flavor_id, :price

          options = {
            'InstanceCount'                                  => instance_count,
            'LaunchSpecification.KeyName'                    => key_name,
            'LaunchSpecification.Placement.AvailabilityZone' => availability_zone,
            'LaunchSpecification.SecurityGroup'              => groups,
            'Type'                                           => request_type }

          connection.request_spot_instances(image_id, flavor_id, price, options)
        end

        def ready?
          state == 'active'
        end

      end
    end
  end
end     
