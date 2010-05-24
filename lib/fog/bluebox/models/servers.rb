require 'fog/collection'
require 'fog/bluebox/models/server'

module Fog
  module Bluebox

    class Mock
      def servers
        Fog::Bluebox::Servers.new(:connection => self)
      end
    end

    class Real
      def servers
        Fog::Bluebox::Servers.new(:connection => self)
      end
    end

    class Servers < Fog::Collection

      model Fog::Bluebox::Server

      def all
        data = connection.get_blocks.body['blocks']
        load(data)
      end

      def get(server_id)
        if server_id && server = connection.get_block(server_id).body
          new(server)
        elsif !server_id
          nil
        end
      rescue Excon::Errors::NotFound
        # No server found with that id
        nil
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
