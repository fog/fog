require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/disk'

module Fog
  module Compute
    class VcloudDirector
      class Disks < Collection
        model Fog::Compute::VcloudDirector::Disk

        attribute :vm

        def create(size)
          item_list unless @disks
          data = Fog::Generators::Compute::VcloudDirector::Disks.new(@disks)
          data.add_hard_disk(size)
          response = service.put_disks(vm.id, data.disks)
          service.process_task(response.body)
        end

        def get_by_id(item_id)
          item = item_list.find{ |i| i[:id] == item_id}
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
        
        # Returns only disk drives (OVF resource type 17) and not controllers,
        # etc. See <https://blogs.vmware.com/vapp/2009/11/virtual-hardware-in-ovf-part-1.html>
        def storage_only
          select {|d| d.resource_type == 17}
        end
      end
    end
  end
end
