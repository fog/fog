require 'fog/collection'
require 'fog/terremark/models/server'

module Fog
  module Terremark

    class Mock
      def servers
        Fog::Terremark::Servers.new(:connection => self)
      end
    end

    class Real
      def servers
        Fog::Terremark::Servers.new(:connection => self)
      end
    end

    class Servers < Fog::Collection

      model Fog::Terremark::Server

      def all
        data = connection.get_vdc(vdc_id).body['ResourceEntities'].select do |entity|
          entity['type'] == 'application/vnd.vmware.vcloud.vApp+xml'
        end
        load(data)
      end

      def get(server_id)
        if server_id && server = connection.get_vapp(server_id).body
          new(server)
        elsif !server_id
          nil
        end
      rescue Excon::Errors::Forbidden
        nil
      end

      def vdc_id
        @vdc_id ||= connection.default_vdc_id
      end

      private

      def vdc_id=(new_vdc_id)
        @vdc_id = new_vdc_id
      end

    end

  end
end
