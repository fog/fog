require 'fog/core/collection'
require 'fog/openstack/models/compute/server'

module Fog
  module Compute
    class OpenStack

      class Servers < Fog::Collection

        attribute :filters

        model Fog::Compute::OpenStack::Server

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          data = service.list_servers_detail(filters).body['servers']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = service.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

      end

    end
  end
end
