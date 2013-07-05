require 'fog/core/collection'
require 'fog/vcloudng/models/compute/disk'

module Fog
  module Compute
    class Vcloudng

      class Disks < Fog::Collection
        model Fog::Compute::Vcloudng::Disk
        
        attribute :vm_id
        
        def index
          disks.map{ |disk| new(disk.merge(all_disks: @disks, vm_id: vm_id))}
        end 
        
        def all
          index
        end

        def get(instance_id)
          disk = disks.detect{ |disk| disk['InstanceID'] == instance_id }
          return nil unless disk
          new(disk.merge(all_disks: @disks, vm_id: vm_id))
        end
        
        def get_by_name(disk_name)
          disk = disks.detect{ |disk| disk['element_name'] == disk_name }
          return nil unless disk
          new(disk.merge(all_disks: @disks, vm_id: vm_id))
        end
        
        def create(size)
          disks unless @disks
          data = Fog::Generators::Compute::Vcloudng::Disks.new(@disks)
          data.add_hard_disk(size)
          response = service.put_vm_disks(vm_id, data.disks)
          service.process_task(response.body)
        end
        
        private
        
        def disks
          @disks = service.get_vm_disks(vm_id).body
          @disks['disks']
        end
        
      end
    end
  end
end