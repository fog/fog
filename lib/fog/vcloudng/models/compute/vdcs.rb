require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vdc'

module Fog
  module Compute
    class Vcloudng

      class Vdcs < Fog::Collection
        model Fog::Compute::Vcloudng::Vdc
        
        attribute :organization
        
        def all(organization_id = organization.id)
          data = service.get_organization(organization_id).body
          vdcs = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.vdc+xml" }
          vdc_ids = vdcs.map {|vdc| vdc[:href].split('/').last }
          vdc_ids.map{ |vdc_id| get(vdc_id)} 
        end

        def get(vdc_id)
          data = service.get_vdc(vdc_id).body
          data[:id] = data[:href].split('/').last
          %w(:VdcItems :Link :ResourceEntities).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
      end
    end
  end
end