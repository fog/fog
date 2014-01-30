require 'fog/core/collection'
require 'fog/sakuracloud/models/compute/server'

module Fog
  module Compute
    class SakuraCloud

      class Servers < Fog::Collection
        model Fog::Compute::SakuraCloud::Server

        def all
          load service.list_servers.body['Servers']
        end

        def get(id)
          all.find { |f| f.id == id }
        rescue Fog::Errors::NotFound
          nil
        end

        def create_with(options = {})
          user = options[:user] || 'root'
          Fog::Logger.warning("Create Volume")
          volume = Fog::Volume::SakuraCloud.new(:sakuracloud_api_token => options[:sakuracloud_api_token], :sakuracloud_api_token_secret => options[:sakuracloud_api_token_secret])
          disk = volume.disks.create :name => Fog::UUID.uuid,
                              :plan  => options[:diskplan].to_i,
                              :source_archive => options[:sourcearchive].to_s
          Fog::Logger.warning("Waiting disk until available")
          disk.wait_for { availability == 'available' }
          Fog::Logger.warning("Create Server")
          server = create :name => Fog::UUID.uuid,
                          :server_plan =>  options[:serverplan]
          volume.attach_disk(disk.id, server.id)
          Fog::Logger.warning("Waiting for attach disk")
          server.reload
          disk_attached?(server, disk.id)
          volume.configure_disk(disk.id, options[:sshkey])
          server.boot
          server
        end

        private
        def disk_attached?(server, disk_id)
          until server.disks.find {|s| disk_id.to_s}
            print '.'
            sleep 2
            server.reload
          end
        end
      end

    end
  end
end
