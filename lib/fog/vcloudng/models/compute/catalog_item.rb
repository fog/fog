require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class CatalogItem < Fog::Model
        
        identity  :id
                  
        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :vapp_template_id
        
        def instantiate(vapp_name, options={})
          puts vapp_template_id
          response = service.instantiate_vapp_template(vapp_name, vapp_template_id, options = {})
          task = response.body[:Tasks][:Task]
          task[:id] = task[:href].split('/').last
          service.tasks.new(task)
        end
        
        
      end
    end
  end
end