require 'fog/model'

module Fog
  module Rackspace
    module Servers

      class Server < Fog::Model

        identity :id

        attribute :addresses
        attribute :password,    'adminPass'
        attribute :flavor_id,   'flavorId'
        attribute :host_id,     'hostId'
        attribute :image_id,    'imageId'
        attribute :metadata
        attribute :name
        attribute :personality
        attribute :progress
        attribute :status

        def destroy
          requires :id
          connection.delete_server(@id)
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(@flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(@image_id)
        end

        def images
          requires :id
          connection.images(:server => self)
        end

        def ready?
          @status == 'ACTIVE'
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_server(@id, type)
          true
        end

        def save
          requires :flavor_id, :image_id
          options = {
            'metadata'    => @metadata,
            'name'        => @name,
            'personality' => @personality
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_server(@flavor_id, @image_id, options)
          merge_attributes(data.body['server'])
          true
        end

      end

    end
  end
end
