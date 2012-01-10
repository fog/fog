require 'fog/compute/models/server'

module Fog
  module Compute
    class IBM

      class Server < Fog::Compute::Server

        identity :id

        attribute :disk_size, :aliases => 'diskSize'
        attribute :expires_at, :aliases => 'expirationTime'
        attribute :image_id, :aliases => 'imageId'
        attribute :instance_type, :aliases => 'instanceType'
        attribute :ip
        attribute :key_name, :aliases => 'keyName'
        attribute :launched_at, :aliases => 'launchTime'
        attribute :location_id, :aliases => 'location'
        attribute :name
        attribute :owner
        attribute :primary_ip, :aliases => 'primaryIP'
        attribute :product_codes, :aliases => 'productCodes'
        attribute :request_id, :aliases => 'requestId'
        attribute :request_name, :aliases => 'requestName'
        attribute :root_only, :aliases => 'root-only'
        attribute :secondary_ip, :aliases => 'secondaryIP'
        attribute :software
        attribute :state, :aliases => 'status'
        attribute :volume_ids, :aliases => 'volumes'

        def initialize(new_attributes={})
          super(new_attributes)
          self.name ||= 'fog-instance'
          self.image_id ||= '20025202'
          self.location_id ||= '82'
          self.instance_type ||= 'COP32.1/2048/60'
          self.key_name ||= 'fog'
        end

        def save
          requires :name, :image_id, :instance_type, :location_id
          data = connection.create_instance(name, image_id, instance_type, location_id, key_name)
          data.body['instances'].each do |iattrs|
            if iattrs['name'] == name
              merge_attributes(iattrs)
              return true
            end
          end
          false
        end

        def reboot
          requires :id
          connection.modify_instance(id, 'state' => 'restart')
        end

        def destroy
          requires :id
          data = connection.delete_instance(id)
          data.body['success']
        end

        def attach(volume_id)
          requires :id
          data = connection.modify_instance(id, {'type' => 'attach', 'storageId' => volume_id})
          data.body
        end

        def detach(volume_id)
          requires :id
          data = connection.modify_instance(id, {'type' => 'detach', 'storageId' => volume_id})
          data.body
        end

        def ready?
          state == 5
        end

      end

    end
  end

end
