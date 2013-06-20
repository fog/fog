require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vapp'

module Fog
  module Compute
    class Vcloudng

      class Vapps < Fog::Collection
        model Fog::Compute::Vcloudng::Vapp
        
        attribute :vdc
        
        def all(vdc_id = vdc.id)
          data = service.get_vdc(vdc_id).body
          vapps = data[:ResourceEntities][:ResourceEntity].select { |link| link[:type] == "application/vnd.vmware.vcloud.vApp+xml" }
          vapp_ids = vapps.map {|vapp| vapp[:href].split('/').last }
          vapp_ids.map{ |vapp_id| get(vapp_id)} 
        end

        def get(vapp_id)
          data = service.get_vapp(vapp_id).body
          data[:id] = data[:href].split('/').last
          %w(:Link).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
      end
    end
  end
end