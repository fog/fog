require 'fog/core/collection'
require 'fog/openstack/models/compute/server'

module Fog
  module Compute
    class OpenStack

      class Servers < Fog::Collection

        model Fog::Compute::OpenStack::Server

        def all
          data = connection.list_servers_detail.body['servers']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = connection.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

        def find_by_name(name)
          find_by_attribute('name', name)
        end

        def find_by_status(status)
          find_by_attribute('status', status)
        end

        def find_by_image(image)
          find_by_attribute('image', image)
        end

        def find_by_flavor(flavor)
          find_by_attribute('flavor', flavor)
        end

        def find_by_changes_since(isotime)
          find_by_attribute('changes-since', isotime)
        end

        def find_by_reservation_id(reservation_id)
          find_by_attribute('reservation_id', reservation_id)
        end

        def find_by_attribute(attribute, value)
          load(connection.list_servers_detail({attribute => value}).body['servers'])
        end

      end

    end
  end
end
