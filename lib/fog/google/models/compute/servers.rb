require 'fog/core/collection'
require 'fog/google/models/compute/server'

module Fog
  module Compute
    class Google

      class Servers < Fog::Collection

        model Fog::Compute::Google::Server

        def all(filters={})
          if filters['zone'].nil?
            data = []
            service.list_zones.body['items'].each do |zone|
              data += service.list_servers(zone['name']).body["items"] || []
            end
          else
            data = service.list_servers(filters['zone']).body["items"] || []
          end
          load(data)
        end

        def get(identity, zone=nil)
          response = nil
          if zone.nil?
            service.list_zones.body['items'].each do |zone|
              begin
                response = service.get_server(identity, zone['name'])
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          else
            response = service.get_server(identity, zone)
          end

          if response.nil? or response.status != 200
            nil
          else
            new(response.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def bootstrap(new_attributes = {})
          name = "fog-#{Time.now.to_i}"
          zone = "us-central1-b"

          disks = new_attributes[:disks]

          if disks.nil? or disks.empty?
            # create the persistent boot disk
            disk_defaults = {
              :name => name,
              :size_gb => 10,
              :zone_name => zone,
              :source_image => "debian-7-wheezy-v20131120",
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
