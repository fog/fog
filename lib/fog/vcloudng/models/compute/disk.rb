require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Disk < Fog::Model
        
        
        identity  :id, :aliases => 'instance_id'
        identity  :vm_id
        
                  
        attribute :address
        attribute :description
        attribute :element_name
        attribute :instance_id
        attribute :resource_sub_type
        attribute :resource_type
        attribute :address_on_parent
        attribute :parent
        attribute :capacity
        attribute :bus_sub_type
        attribute :bus_type
        
        def save
          if capacity_changed?
            puts "Debug: change the cpu from #{attributes[:old_capacity]} to #{attributes[:capacity]}"
            set_capacity(capacity)
            attributes[:capacity_task]
          end
        end
        
        def capacity=(new_capacity)
          attributes[:old_capacity] ||= attributes[:capacity]
          attributes[:capacity] = new_capacity.to_i
        end
        
        def capacity_changed?
          return false unless attributes[:old_capacity]
          attributes[:capacity] != attributes[:old_capacity]
        end
        
        def set_capacity(new_capacity)
          data = Fog::Generators::Compute::Vcloudng::Disks.new(all_disks)
          num_disk = element_name.scan(/\d+/).first.to_i
          data.modify_hard_disk_size(num_disk, new_capacity)
          response = service.put_vm_disks(vm_id, data.disks)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:capacity_task] = service.tasks.new(task)
        end
        
        def all_disks
          attributes[:all_disks] # this is passed at instantiation time
        end
        
        def destroy
          num_disk = element_name.scan(/\d+/).first.to_i
          data = Fog::Generators::Compute::Vcloudng::Disks.new(all_disks)
          data.delete_hard_disk(num_disk)
          response = service.put_vm_disks(vm_id, data.disks)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:destroy_disk_task] = service.tasks.new(task)
        end

      end
    end
  end
end