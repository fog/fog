require 'fog/core/collection'
require 'fog/vcloudng/models/compute/disk'

module Fog
  module Compute
    class Vcloudng

      class Disks < Collection
        model Fog::Compute::Vcloudng::Disk
        
        attribute :vm
        
#        def index
#          disks.map{ |disk| new(disk.merge(all_disks: @disks, vm_id: vm_id))}
#        end 
#        
#        def all
#          index
#        end
#
#        def get(instance_id)
#          disk = disks.detect{ |disk| disk['InstanceID'] == instance_id }
#          return nil unless disk
#          new(disk.merge(all_disks: @disks, vm_id: vm_id))
#        end
#        
#        def get_by_name(disk_name)
#          disk = disks.detect{ |disk| disk['element_name'] == disk_name }
#          return nil unless disk
#          new(disk.merge(all_disks: @disks, vm_id: vm_id))
#        end
        
        def create(size)
          item_list unless @disks
          data = Fog::Generators::Compute::Vcloudng::Disks.new(@disks)
          puts data
          puts data.disks
          data.add_hard_disk(size)
          response = service.put_vm_disks(vm.id, data.disks)
          service.process_task(response.body)
        end
        
        def get_by_id(item_id)
          item = item_list.detect{ |i| i[:id] == item_id}
          item.merge!(:all_disks => @disks, :vm => vm) if item
          item
        end
                        
        def item_list
          @disks = service.get_vm_disks(vm.id).body
          items = @disks[:disks]
          items.each do |disk| 
            disk[:all_disks] = @disks 
            disk[:vm] = vm
          end
          items
        end
        
#        private
        
#        def disks
#          @disks = service.get_vm_disks(vm_id).body
#          @disks['disks']
#        end
        
      end
    end
  end
end