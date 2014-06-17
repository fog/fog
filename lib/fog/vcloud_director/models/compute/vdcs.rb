require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vdc'

module Fog
  module Compute
    class VcloudDirector
      class Vdcs < Collection

        include Fog::VcloudDirector::Query

        model Fog::Compute::VcloudDirector::Vdc

        attribute :organization

        def query_type
          "orgVdc"
        end

        private

        def get_by_id(item_id)
          item = service.get_vdc(item_id).body
          %w(:VdcItems :Link :ResourceEntities).each {|key_to_delete| item.delete(key_to_delete) }
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_organization(organization.id).body
          items = data[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.vdc+xml" }
          items.each{|item| service.add_id_from_href!(item) }
          items
        end
      end
    end
  end
end
