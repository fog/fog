require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vm'

module Fog
  module Compute
    class Vcloudng

      class Vms < Collection
        model Fog::Compute::Vcloudng::Vm
        
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