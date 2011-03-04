require 'fog/core/collection'
require 'fog/compute/models/linode/disk'

module Fog
  module Linode
    class Compute
      class Disks < Fog::Collection
        model Fog::Linode::Compute::Disk

        def all(linode_id)
          load disks(linode_id)
        end

        def get(linode_id, id)
          new disks(linode_id, id).first
        rescue Fog::Linode::Compute::NotFound
          nil
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
