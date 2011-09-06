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

        def get(instance_uuid)
          vm_mob = connection.find_all_by_instance_uuid(instance_uuid).first
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
