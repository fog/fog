require 'fog/core/collection'
require 'fog/vcloudng/models/compute/network'

module Fog
  module Compute
    class Vcloudng

      class Networks < Fog::Collection
        model Fog::Compute::Vcloudng::Network
        
        attribute :organization
        
        def index(organization_id = organization.id)
          network_links(organization_id).map{ |network| new(network)}
        end 
        
        def all(organization_id = organization.id)
          network_ids = network_links(organization_id).map {|network| network[:id] }
          network_ids.map{ |network_id| get(network_id)} 
        end

        def get(network_id)
          data = service.get_network(network_id).body
          new(data)
        end
        
        def get_by_name(network_name, organization_id = organization.id)
          network = network_links(organization_id).detect{|network_link| network_link[:name] == network_name }
          return nil unless network
          network_id = network[:id]
          get(network_id)
        end
        
#        private
        
        def network_links(organization_id)
          data = service.get_organization(organization_id).body
          networks = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.orgNetwork+xml" }
          networks.each{|network| network[:id] = network[:href].split('/').last }
          networks
        end
        
      end
    end
  end
end
