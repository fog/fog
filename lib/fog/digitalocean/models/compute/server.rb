require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOcean
      # 
      # A DigitalOcean Droplet
      #
      class Server < Fog::Compute::Server
        
        identity  :id
        attribute :name
        attribute :status
        attribute :image_id
        attribute :region_id
        attribute :flavor_id,         :aliases => :size_id
        attribute :backups_active

        def reboot
        end

        def shutdown
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :flavor_id, :image_id, :region_id
          meta_hash = {}
          options = {
            'name'        => name,
            'size_id'     => flavor_id,
            'image_id'    => image_id,
            'region_id'   => region_id,
          }
          data = service.create_server name, flavor_id, image_id, region_id
          merge_attributes(data.body['droplet'])
          true
        end

        def destroy
          service.destroy_server id
        end

        def ready?
          status == 'active'
        end
      end
    end
  end
end
