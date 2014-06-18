require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vm'

module Fog
  module Compute
    class VcloudDirector
      class Vms < Collection

        include Fog::VcloudDirector::Query

        model Fog::Compute::VcloudDirector::Vm

        attribute :vapp

        def get_by_metadata(key, value)
          data = service.get_vms_by_metadata(key, value).body
          items = data[:vm_records]
          load(items)
        end

        def get_single_vm(vm_id)
          item = service.get_vm(vm_id).body
          return nil unless item
          new(item[:vm])
        end

        def query_type
          "vm"
        end

        private

        def get_by_id(item_id)
          item = item_list.find{ |vm| vm[:id] == item_id }
          item
        end

        def item_list
          data = service.get_vms(vapp.id).body  # vapp.id
          items = data[:vms]
          items
        end
      end
    end
  end
end
