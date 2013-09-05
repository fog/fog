require 'fog/core/model'
require 'fog/vcloud_director/models/compute/vm_customization'


module Fog
  module Compute
    class VcloudDirector

      class Vm < Model
        identity  :id

        attribute :vapp_id
        attribute :vapp_name
        attribute :name
        attribute :type
        attribute :href
        attribute :status 
        attribute :operating_system
        attribute :ip_address
        attribute :cpu, :type => :integer
        attribute :memory
        attribute :hard_disks, :aliases => :disks
                
        
        def reload
          # when collection.vapp is nil, it means it's fatherless, 
          # vms from different vapps are loaded in the same collection.
          # This situation comes from a "query" result
          collection.vapp.nil? ? reload_single_vm : super
        end
        
        def reload_single_vm
          return unless data = begin
            collection.get_single_vm(identity)
          rescue Excon::Errors::SocketError
            nil
          end
          # these two attributes don't exists in the get_single_vm response
          # that's why i use the old attributes
          data.attributes[:vapp_id] = attributes[:vapp_id]
          data.attributes[:vapp_name] = attributes[:vapp_name]
          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end
        
        
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