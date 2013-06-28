require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class VmCustomization < Fog::Model
        
        identity  :id
                  
        attribute :type
        attribute :href
        attribute :enabled
        attribute :change_sid
        attribute :join_domain_enabled
        attribute :use_org_settings
        attribute :admin_password_enabled
        attribute :reset_password_required
        attribute :virtual_machine_id
        attribute :computer_name
        attribute :has_customization_script
        
        def script
          attributes[:customization_script]
        end
        
        def script=(new_script)
          attributes[:customization_script] = new_script
        end
        
        def save
          response = service.put_vm_customization(id, attributes)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:customization_task] = service.tasks.new(task)
        end
        
        
      end
    end
  end
end