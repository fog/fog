require 'fog/core/collection'
require 'fog/vsphere/models/compute/server'

module Fog
  module Compute
    class Vsphere

      class Servers < Fog::Collection

        model Fog::Compute::Vsphere::Server

        def all
          # Virtual Machine Managed Objects (vm_mobs)
          vm_mobs = connection.list_virtual_machines
          vm_attributes = vm_mobs.collect do |vm_mob|
            model.attribute_hash_from_mob(vm_mob)
          end

          load(vm_attributes)
        end

        def get(id)
          # Is the id a managed_object_reference?  This may be the case if we're reloading
          # a model of a VM in the process of being cloned, since it
          # will not have a instance_uuid yet.
          if id =~ /^vm-/
            vm_mob = connection.find_vm_by_ref(:vm_ref => id)
          else
            vm_mob = connection.find_all_by_instance_uuid(id).first
          end
          if server_attributes = model.attribute_hash_from_mob(vm_mob)
            new(server_attributes)
          end
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end

      end

    end
  end
end
