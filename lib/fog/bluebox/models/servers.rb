require 'fog/collection'
require 'fog/bluebox/models/server'

module Fog
  module Bluebox

    module Collections
      def servers
        Fog::Bluebox::Servers.new(:connection => self)
      end
    end

    class Servers < Fog::Collection

      model Fog::Bluebox::Server

      def all
        data = connection.get_blocks.body
        load(data)
      end

      def get(server_id)
        if server_id && server = connection.get_block(server_id).body
          new(server)
        end
      rescue Fog::Bluebox::NotFound
        nil
      end

    end

  end
end
