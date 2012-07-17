require 'fog/core/collection'
require 'fog/vsphere/models/storage/volume'

module Fog
  module Storage
    class Vsphere

      class Volumes < Fog::Collection

        model Fog::Storage::Vsphere::Volume

        def all(vm_mo_ref)
          response = connection.get_disks_by_vm_mob(vm_mo_ref)
          load(response['volume_info'])
        end

        def get(vm_mo_ref, device_name = nil)
          volume_attributes = nil
          if !(device_name.nil?)
            response = connection.get_disks_by_vm_mob_and_device_name(vm_mo_ref, device_name)
            volume_attributes = response['volume_info'].first
          end
          new(volume_attributes)
        rescue Fog::Storage::Vsphere::NotFound
          nil
        end

      end  # end of Volumes

    end
  end
end
