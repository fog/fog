require 'fog/core/collection'
require 'fog/google/models/compute/server'

module Fog
  module Compute
    class Google
      class Servers < Fog::Collection
        model Fog::Compute::Google::Server

        def all(filters={})
          if filters['zone']
            data = service.list_servers(filters['zone']).body['items'] || []
          else
            data = []
            service.list_aggregated_servers.body['items'].each_value do |zone|
              data.concat(zone['instances']) if zone['instances']
            end
          end
          load(data)
        end

        def get(identity, zone=nil)
          response = nil
          if zone
            response = service.get_server(identity, zone).body
          else
            servers = service.list_aggregated_servers(:filter => "name eq .*#{identity}").body['items']
            server = servers.each_value.select { |zone| zone.key?('instances') }

            # It can only be 1 server with the same name across all regions
            response = server.first['instances'].first unless server.empty?
          end
          return nil if response.nil?
          new(response)
        rescue Fog::Errors::NotFound
          nil
        end

        def bootstrap(new_attributes = {})
          name = "fog-#{Time.now.to_i}"
          zone = "us-central1-a"

          disks = new_attributes[:disks]

          if disks.nil? or disks.empty?
            # create the persistent boot disk
            disk_defaults = {
              :name => name,
              :size_gb => 10,
              :zone_name => zone,
              :source_image => "debian-7-wheezy-v20140408",
            }

            # backwards compatibility to pre-v1
            new_attributes[:source_image] = new_attributes[:image_name] if new_attributes[:image_name]

            disk = service.disks.create(disk_defaults.merge(new_attributes))
            disk.wait_for { disk.ready? }
            disks = [disk]
          end

          defaults = {
            :name => name,
            :disks => disks,
            :machine_type => "n1-standard-1",
            :zone_name => zone,
            :private_key_path => File.expand_path("~/.ssh/id_rsa"),
            :public_key_path => File.expand_path("~/.ssh/id_rsa.pub"),
            :username => ENV['USER'],
          }

          server = create(defaults.merge(new_attributes))
          server.wait_for { sshable? }

          server
        end
      end
    end
  end
end
