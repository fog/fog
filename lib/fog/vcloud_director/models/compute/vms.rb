require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vm'

module Fog
  module Compute
    class VcloudDirector

      class Vms < Collection
        model Fog::Compute::VcloudDirector::Vm
        
        attribute :vapp
        
        private
                
        def get_by_id(item_id)
          item = item_list.detect{ |vm| vm[:id] == item_id}
          item
        end
                        
        def item_list
          data = service.get_vms(vapp.id).body
          items = data[:vms]
          items
        end
        
      end
    end
  end
end