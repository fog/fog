require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vm'

module Fog
  module Compute
    class Vcloudng

      class Vms < Fog::Collection
        model Fog::Compute::Vcloudng::Vm
        
        attribute :vapp
        
        def index(vapp_id = vapp.id)
          vm_links(vapp_id).map{ |vm| new(vm)}
        end 
        
        def all(vapp_id = vapp.id)
          index(vapp_id = vapp.id)
        end

        def get(vm_id, vapp_id = vapp.id)
          vm = vm_links(vapp_id).detect{ |vm| vm[:id] == vm_id}
          new(vm)
        end
        
        def get_by_name(vm_name, vapp_id = vapp.id)
          vm = vm_links(vapp_id).detect{ |vm| vm[:name] == vm_name}
          new(vm)
        end
        
        private
        
        def vm_links(vapp_id)
          data = service.get_vms(vapp_id).body
          data['vms']
        end
        
      end
    end
  end
end