require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Disk < Model # there is no lazy_load in disks
        identity  :id

        attribute :address
        attribute :description
        attribute :name
        attribute :resource_sub_type
        attribute :resource_type
        attribute :address_on_parent
        attribute :parent
        attribute :capacity
        attribute :bus_sub_type
        attribute :bus_type

        # TODO Virtual machine disk sizes may only be increased, not decreased.
        def capacity=(new_capacity)
          has_changed = ( capacity != new_capacity.to_i )
          not_first_set = !capacity.nil?
          attributes[:capacity] = new_capacity.to_i
          if not_first_set && has_changed
            data = Fog::Generators::Compute::VcloudDirector::Disks.new(all_disks)
            num_disk = name.scan(/\d+/).first.to_i
            data.modify_hard_disk_size(num_disk, new_capacity)
            response = service.put_disks(attributes[:vm].id, data.disks)
            service.process_task(response.body)
          end
        end

        def all_disks
          attributes[:all_disks] # this is passed at instantiation time
        end

        def destroy
          num_disk = name.scan(/\d+/).first.to_i
          data = Fog::Generators::Compute::VcloudDirector::Disks.new(all_disks)
          data.delete_hard_disk(num_disk)
          response = service.put_disks(attributes[:vm].id, data.disks)
          service.process_task(response.body)
        end
      end
    end
  end
end
