module Fog
  module Rackspace
    class Servers

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :created
        attribute :updated
        attribute :status
        attribute :server_id,   'serverId'

        def server=(new_server)
          @server_id = new_server.id
        end

        def destroy
          connection.delete_image(@id)
          true
        end

        def save
          data = connection.create_server(@server_id)
          merge_attributes(data.body['image'])
          true
        end

      end

    end
  end
end
