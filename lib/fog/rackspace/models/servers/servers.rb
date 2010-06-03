require 'fog/collection'
require 'fog/rackspace/models/servers/server'

module Fog
  module Rackspace
    module Servers

      class Mock
        def servers
          Fog::Rackspace::Servers::Servers.new(:connection => self)
        end
      end

      class Real
        def servers
          Fog::Rackspace::Servers::Servers.new(:connection => self)
        end
      end

      class Servers < Fog::Collection

        model Fog::Rackspace::Servers::Server

        def all
          data = connection.list_servers_detail.body['servers']
          load(data)
        end

        def get(server_id)
          if server = connection.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Rackspace::Servers::NotFound
          nil
        end

      end

    end
  end
end
