require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vm_customization'

module Fog
  module Compute
    class VcloudDirector
      class VmCustomizations < Collection
        model Fog::Compute::VcloudDirector::VmCustomization

        attribute :vm

        private

        def get_by_id(item_id)
          item = service.get_vm_customization(item_id).body
          add_id_from_href!(item)
          item
        end

        # The HREF returned for a VM customization object is actually the VM
        # HREF suffixed with '/guestCustomizationSection/' so we cannot use
        # service.add_id_from_href! like all other collections.
        def add_id_from_href!(item={})
          item[:id] = item[:href].gsub('/guestCustomizationSection/', '').split('/').last
        end
      end
    end
  end
end
