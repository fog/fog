module Fog
  module Rackspace
    class Servers

      def servers
        Fog::Rackspace::Servers::Servers.new(:connection => self)
      end

      class Servers < Fog::Collection

        model Fog::Rackspace::Servers::Server

        def all
          if @loaded
            clear
          end
          @loaded = true
          data = connection.list_servers_detail.body
          for server in data['servers']
            self << new(server)
          end
          self
        end

        def get(server_id)
          if server = connection.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
