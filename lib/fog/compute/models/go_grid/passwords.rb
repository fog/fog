require 'fog/core/collection'
require 'fog/compute/models/go_grid/password'

module Fog
  module GoGrid
    class Compute

      class Passwords < Fog::Collection

        model Fog::GoGrid::Compute::Password

        def all
          data = connection.support_password_list.body['list']
          load(data)
        end

        def bootstrap(new_attributes = {})
          password = create(new_attributes)
          password.wait_for { ready? }
          password
        end

        def get(id)
          #if server_id && server = connection.grid_server_get(server_id).body['list']
          if id && server = connection.support_password_get(id).body['list']
            new(server)
          end
        rescue Fog::GoGrid::Compute::NotFound
          nil
        end

      end

    end
  end
end
