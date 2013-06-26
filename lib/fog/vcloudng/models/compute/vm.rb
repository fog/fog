require 'fog/core/model'
require 'fog/vcloudng/models/compute/vm_customization'


module Fog
  module Compute
    class Vcloudng

      class Vm < Fog::Model
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :status 
        attribute :operating_system
        attribute :ip_address
        attribute :cpu, :type => :integer
        attribute :memory
#        attribute :disks
            
        def customization
          data = service.get_vm_customization(id).body
          puts data
          service.vm_customizations.new(data)
        end
        
        def save
          if cpu_changed?
            puts "Debug: change the cpu from #{attributes[:old_cpu]} to #{attributes[:cpu]}"
            set_cpu(cpu)
            attributes[:cpu_task].wait_for { :ready? }
          end
        end
        
        def cpu=(new_cpu)
          attributes[:old_cpu] ||= attributes[:cpu]
          attributes[:cpu] = new_cpu.to_i
        end
        
        def cpu_changed?
          return false unless attributes[:old_cpu]
          attributes[:cpu] != attributes[:old_cpu]
        end
        
        def set_cpu(num_cpu)
          response = service.put_vm_cpu(id, num_cpu)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:cpu_task] = service.tasks.new(task)
        end
        
        def cpu_task
          attributes[:cpu_task]
        end
        
      end
    end
  end
end