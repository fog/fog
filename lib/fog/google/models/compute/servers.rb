require 'fog/core/collection'
require 'fog/google/models/compute/server'

module Fog
  module Compute
    class Google

      class Servers < Fog::Collection

        model Fog::Compute::Google::Server

        def all(zone=nil)
          if zone.nil?
            data = []
            service.list_zones.body['items'].each do |zone|
              data += service.list_servers(zone['name']).body["items"] || []
            end
          else
            data = service.list_servers(zone).body["items"] || []
          end
          load(data)
        end

        def get(identity, zone=nil)
          data = nil
          if zone.nil?
            service.list_zones.body['items'].each do |zone|
              data = service.get_server(identity, zone['name']).body
              break if data["code"] == 200
            end
          else
            data = service.get_server(identity, zone).body
          end

          if data["code"] != 200
            nil
          else
            new(data)
          end
        rescue Excon::Errors::NotFound
          nil
        end

        def bootstrap(new_attributes = {})
          defaults = {
            :name => "fog-#{Time.now.to_i}",
            :image_name => "gcel-12-04-v20130225",
            :machine_type => "n1-standard-1",
            :zone_name => "us-central1-a",
            :private_key_path => File.expand_path("~/.ssh/id_rsa"),
            :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
          }

          server = create(defaults.merge(new_attributes))
          server.wait_for(Fog.timeout, 30) { ready? }
          server
        end
      end
    end
  end
end
