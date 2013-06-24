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
        attribute :admin_password_enabled
        attribute :reset_password_required
        attribute :virtual_machine_id
        attribute :computer_name
        attribute :has_customization_script
      
        def initialize(new_attributes = {})
          @customization_script = new_attributes['customization_script']
          super(new_attributes)
        end
        
        def customization_script
          @customization_script
        end
        
      end
    end
  end
end