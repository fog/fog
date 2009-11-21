module Fog
  module Rackspace
    class Servers

      class Server < Fog::Model

        identity :id

        attribute :admin_pass,  'adminPass'
        attribute :name
        attribute :image_id,    'imageId'
        attribute :flavor_id,   'flavorId'
        attribute :host_id,     'hostId'
        attribute :status
        attribute :personality
        attribute :progress
        attribute :addresses
        attribute :metadata

        def destroy
          connection.delete_server(@id)
          true
        end

        def images
          connection.images(:server => self)
        end

        def reboot(type = 'SOFT')
          connection.reboot_server(@id, type)
          true
        end

        def save
          options = { 'metadata' => @metadata, 'personality' => @personality }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_server(@flavor_id, @image_id, @name, options)
          merge_attributes(data.body['server'])
          true
        end

      end

    end
  end
end
