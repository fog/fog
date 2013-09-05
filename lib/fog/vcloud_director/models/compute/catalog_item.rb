require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class CatalogItem < Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :vapp_template_id
        
        def instantiate(vapp_name, options={})
          response = service.instantiate_vapp_template(vapp_name, vapp_template_id, options)
          service.process_task(response.body[:Tasks][:Task])
        end
        
        
      end
    end
  end
end
