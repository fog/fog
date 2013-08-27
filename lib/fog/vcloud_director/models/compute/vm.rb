require 'fog/core/model'
require 'fog/vcloud_director/models/compute/vm_customization'


module Fog
  module Compute
    class VcloudDirector

      class Vm < Model
        identity  :id

        attribute :vapp_id                  
        attribute :name
        attribute :type
        attribute :href
        attribute :status 
        attribute :operating_system
        attribute :ip_address
        attribute :cpu, :type => :integer
        attribute :memory
        attribute :hard_disks, :aliases => :disks
        
        
        def power_on
          response = service.post_vm_poweron(id)
          service.process_task(response.body)
        end
        
        def tags
          requires :id
          service.tags(:vm => self)
        end
            
        def customization
          data = service.get_vm_customization(id).body
          service.vm_customizations.new(data)
        end
        
        def network
          data = service.get_vm_network(id).body
          service.vm_networks.new(data)
        end
        
        def disks
          requires :id
          service.disks(:vm => self)
        end
        
        #def reload
        #  service.vms(:vapp_id => vapp_id).get(id)
        #end
        
        def memory=(new_memory)
          has_changed = ( memory != new_memory.to_i )
          not_first_set = !memory.nil?
          attributes[:memory] = new_memory.to_i
          if not_first_set && has_changed
            response = service.put_vm_memory(id, memory)
            service.process_task(response.body)
          end
        end
        
        def cpu=(new_cpu)
          has_changed = ( cpu != new_cpu.to_i )
          not_first_set = !cpu.nil?
          attributes[:cpu] = new_cpu.to_i
          if not_first_set && has_changed
            response = service.put_vm_cpu(id, cpu)
            service.process_task(response.body)
          end
        end

        
      end
    end
  end
end