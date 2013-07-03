require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class Tag < Fog::Model
        
        
        identity  :id, :aliases => :key
        attribute :value

        
        def save
          if value_changed?
            puts "Debug: change the value from #{attributes[:old_value]} to #{attributes[:value]}"
            set_value(value)
            attributes[:value_task].wait_for { :ready? }
          end
        end
        
        def value=(new_value)
          attributes[:old_value] ||= attributes[:value]
          attributes[:value] = new_value
        end
        
        def value_changed?
          return false unless attributes[:old_value]
          attributes[:value] != attributes[:old_value]
        end
        
        def set_value(new_value)
          response = service.put_vm_metadata_value(attributes[:vm_id], id, value)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:value_task] = service.tasks.new(task)
        end
        
        def destroy
          response = service.delete_vm_metadata(attributes[:vm_id], id)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:destroy_tag_task] = service.tasks.new(task)
        end

      end
    end
  end
end
