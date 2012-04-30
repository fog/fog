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
          if server_id && server = connection.get_vapp(server_id).body
            server = new(server)

            #Find the Public IP Address
            #Identify Public IP address by matching Internet Service name with Server Name
            services = connection.get_internet_services(connection.default_vdc_id)
            internet_info = services.body["InternetServices"].find {|item| item["Name"] == server.name}

            if internet_info
                nodes = connection.get_node_services(internet_info["Id"])
                if nodes.body["NodeServices"].find{|item| item["IpAddress"] == server.IpAddress }
                    server.PublicIpAddress = internet_info["PublicIpAddress"]["Name"] 
                end
            end

            server
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
end
