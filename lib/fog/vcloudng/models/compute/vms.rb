require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vm'

module Fog
  module Compute
    class Vcloudng

      class Vms < Fog::Collection
        model Fog::Compute::Vcloudng::Vm
        
        attribute :vapp
        
        def index
          vm_links.map{ |vm| new(vm)}
        end 
        
        def all
          index
        end

        def get(vm_id)
          puts vapp.id
          vm = vm_links.detect{ |vm| vm[:id] == vm_id}
          puts vm
          new({ :vapp => vapp }.merge(vm))
        end
        
        def get_by_name(vm_name)
          vm = vm_links.detect{ |vm| vm[:name] == vm_name}
          new(vm)
        end
        
        #def new(attributes = {})
        #  puts attributes
        #  puts attributes.class
        #  if vapp
        #    puts "there is a vapp #{vapp.inspect}"
        #    super({ :vapp => vapp }.merge!(attributes))
        #  else
        #    super(attributes)
        #  end
        #end
        
        private
        
        def vm_links
          data = service.get_vms(vapp.id).body
          data['vms']
        end
        
      end
    end
  end
end