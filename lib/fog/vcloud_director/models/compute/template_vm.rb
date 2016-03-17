require 'fog/core/model'
require 'fog/vcloud_director/models/compute/vm_customization'

module Fog
  module Compute
    class VcloudDirector
      class TemplateVm < Model
        identity  :id

        attribute :vapp_template_id
        attribute :vapp_template_name
        attribute :name
        attribute :type
        attribute :href

        def reload
          #Parent vapp_name & id are nil on a template_vm. Adding them from the collection parent
          self.vapp_template_id = collection.vapp_template.id
          self.vapp_template_name = collection.vapp_template.name
        end


        def tags
          requires :id
          service.tags(:vm => self)
        end

        def customization
          requires :id
          data = service.get_vm_customization(id).body
          service.vm_customizations.new(data)
        end

        def network
          requires :id
          data = service.get_vm_network(id).body
          service.vm_networks.new(data)
        end

        def disks
          requires :id
          service.disks(:vm => self)
        end
        

        def vapp_template
          service.vapp_templates.get(vapp_template_id)
        end
      end
    end
  end
end
