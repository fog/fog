module Fog
  module Rackspace
    class Servers

      def servers
        Fog::Rackspace::Servers::Servers.new(:connection => self)
      end

      class Servers < Fog::Collection

        model Fog::Rackspace::Servers::Server

        def all
          data = connection.list_servers_detail.body
          servers = Fog::Rackspace::Servers::Servers.new({
            :connection => connection
          })
          for server in data['servers']
            servers << Fog::Rackspace::Servers::Server.new({
              :collection => servers,
              :connection => connection
            }.merge!(server))
          end
          servers
        end

        def get(server_id)
          connection.get_server_details(server_id)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
