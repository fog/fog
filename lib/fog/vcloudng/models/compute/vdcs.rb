require 'fog/core/collection'
require 'fog/vcloudng/models/compute/vdc'

module Fog
  module Compute
    class Vcloudng

      class Vdcs < Fog::Collection
        model Fog::Compute::Vcloudng::Vdc
        
        attribute :organization
        
        def index(organization_id = organization.id)
          vdc_links(organization_id).map{ |vdc| new(vdc)}
        end 
        
        def all(organization_id = organization.id)
          vdc_ids = vdc_links(organization_id).map {|vdc| vdc[:id] }
          vdc_ids.map{ |vdc_id| get(vdc_id)} 
        end

        def get(vdc_id)
          data = service.get_vdc(vdc_id).body
          data[:id] = data[:href].split('/').last
          %w(:VdcItems :Link :ResourceEntities).each {|key_to_delete| data.delete(key_to_delete) }
          new(data)
        end
        
        def get_by_name(vdc_name, organization_id = organization.id)
          vdc = vdc_links(organization_id).detect{|vdc_link| vdc_link[:name] == vdc_name }
          return nil unless vdc
          get(vdc[:id])
        end
        
        private
        
        def vdc_links(organization_id)
          data = service.get_organization(organization_id).body
          vdcs = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.vdc+xml" }
          vdcs.each{|vdc| vdc[:id] = vdc[:href].split('/').last }
          vdcs
        end
        
      end
    end
  end
end