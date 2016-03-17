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

        
        def vapp_template
          requires :id
          service.vapp_templates.get(self.vapp_template_id)
        end
        
        
        def instantiate(vapp_name, options={})
          response = service.instantiate_vapp_template(vapp_name, vapp_template_id, options)
          service.process_task(response.body[:Tasks][:Task])
          response.body[:href].split('/').last # returns the vapp_id if it was instantiated successfully .
        end
      end
    end
  end
end
