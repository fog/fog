module Fog
  module Rackspace
    class Servers

      class Server < Fog::Model

        attribute :admin_pass,  'adminPass'
        attribute :id
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

        def reload
          new_attributes = servers.get(@id).body['server']
          merge_attributes(new_attributes)
        end

        def save
          options = { 'metadata' => @metadata, 'name' => @name, 'personality' => @personality }
          options = options.reject {|key, value| value.nil?}
          p @personality
          p options
          data = connection.create_server(@flavor_id, @image_id, options)
          merge_attributes(data.body['server'])
          true
        end

        def servers
          @servers
        end

        private

        def servers=(new_servers)
          @servers = new_servers
        end

      end

    end
  end
end
