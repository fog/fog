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

        def create(options = {})
          user = options[:user] || 'root'
          Fog::Logger.warning("Create Server")
          data = service.create_server(Fog::UUID.uuid, options[:serverplan]).body["Server"]
          server = service.servers.new
          server.merge_attributes(data)

          if options[:volume]
            disk = create_and_attach_volume(server, options)
            server.reload
          end
          server.boot if options[:boot]
          server
        end

        private
        def create_and_attach_volume(server, options)
            Fog::Logger.warning("Create Volume")
            sakuracloud_api_token        = options[:sakuracloud_api_token] || Fog.credentials[:sakuracloud_api_token]
            sakuracloud_api_token_secret = options[:sakuracloud_api_token_secret] || Fog.credentials[:sakuracloud_api_token_secret]
            volume = Fog::Volume::SakuraCloud.new(:sakuracloud_api_token => sakuracloud_api_token, :sakuracloud_api_token_secret => sakuracloud_api_token_secret)
            disk = volume.disks.create :name => Fog::UUID.uuid,
                                :plan  => options[:volume][:diskplan].to_i,
                                :source_archive => options[:volume][:sourcearchive].to_s
            Fog::Logger.warning("Waiting disk until available")
            disk.wait_for { availability == 'available' }
            volume.attach_disk(disk.id, server.id)
            disk_attached?(server, disk.id)
            Fog::Logger.warning("Modifing disk")
            volume.configure_disk(disk.id, options[:sshkey])
            disk
        end

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
