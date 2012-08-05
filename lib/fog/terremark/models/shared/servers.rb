require 'fog/core/collection'
require 'fog/terremark/models/shared/server'

module Fog
  module Terremark
    module Shared

      module Mock
        def servers(options = {})
          Fog::Terremark::Shared::Servers.new(options.merge(:connection => self))
        end
      end

      module Real
        def servers(options = {})
          Fog::Terremark::Shared::Servers.new(options.merge(:connection => self))
        end
      end

      class Servers < Fog::Collection

        model Fog::Terremark::Shared::Server

        def all
          data = []
          connection.get_vdc(vdc_id).body['ResourceEntities'].select do |entity|
              data << connection.servers.get(entity["href"].split('/').last)
          end
          data
        end

        def get(server_id)
          if server_id
            new(connection.get_vapp(server_id).body)
          else
            nil
          end
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
end
