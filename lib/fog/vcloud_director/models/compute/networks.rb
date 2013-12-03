require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/network'

module Fog
  module Compute
    class VcloudDirector

      class Networks < Collection
        model Fog::Compute::VcloudDirector::Network

        attribute :organization

        private

        def get_by_id(item_id)
          item = service.get_network(item_id).body
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_organization(organization.id).body
          items = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.orgNetwork+xml" }
          items.each{|item| service.add_id_from_href!(item) }
          items
        end

      end
    end
  end
end
