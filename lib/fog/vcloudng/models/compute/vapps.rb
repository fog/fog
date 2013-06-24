require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vapp'

module Fog
  module Compute
    class Vcloudng

      class Vapps < Fog::Collection
        model Fog::Compute::Vcloudng::Vapp
        
        attribute :vdc
        
        def index(vdc_id = vdc.id)
          vapp_links(vdc_id).map{ |vdc| new(vdc)}
        end 
        
        def all(vdc_id = vdc.id)
          vapp_ids = vapp_links(vdc_id).map {|vapp| vapp[:id] }
          vapp_ids.map{ |vapp_id| get(vapp_id)} 
        end

        def get(vapp_id)
          data = service.get_vapp(vapp_id).body
          data[:id] = data[:href].split('/').last
          %w(:Link).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
        
        def get_by_name(vapp_name, vdc_id = vdc.id)
          vapp = vapp_links(vdc_id).detect{|vapp_link| vapp_link[:name] == vapp_name }
          return nil unless vapp
          get(vapp[:id])
        end
        
#        private
        
        def vapp_links(vdc_id)
          data = service.get_vdc(vdc_id).body
          vapps = data[:ResourceEntities][:ResourceEntity].select { |link| link[:type] == "application/vnd.vmware.vcloud.vApp+xml" }
          vapps.each{|vapp| vapp[:id] = vapp[:href].split('/').last }
          vapps
        end
        
      end
    end
  end
end