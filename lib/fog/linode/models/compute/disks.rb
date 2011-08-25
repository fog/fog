require 'fog/core/collection'
require 'fog/linode/models/compute/disk'

module Fog
  module Compute
    class Linode
      class Disks < Fog::Collection
        model Fog::Compute::Linode::Disk
        attribute :server

        def all
          requires :server
          load disks(server.id)
        end

        def get(id)
          requires :server
          new disks(server.id, id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end

        def new(attributes = {})
          requires :server
          super({ :server => server }.merge!(attributes))
        end

        private
        def disks(linode_id, id=nil)
          connection.linode_disk_list(linode_id, id).body['DATA'].map { |disk| map_disk disk }
        end
        
        def map_disk(disk)
          disk = disk.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          disk.merge! :id => disk[:diskid], :name => disk[:label], :server_id => disk[:linodeid]
        end
      end
    end
  end
end
