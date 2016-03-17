require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vapp'

module Fog
  module Compute
    class VcloudDirector
      class VappTemplates < Collection

        include Fog::VcloudDirector::Query

        model Fog::Compute::VcloudDirector::VappTemplate

        attribute :vdc

        def query_type
          "vAppTemplate"
        end

        private

        def get_by_id(item_id)
          item = service.get_vapp_template(item_id).body
          %w(:Link).each {|key_to_delete| item.delete(key_to_delete) }
          service.add_id_from_href!(item)
          item[:Description] ||= ""
          item
        end

        def item_list
          data = service.get_vdc(vdc.id).body
          return [] if data[:ResourceEntities].empty?
          resource_entities = data[:ResourceEntities][:ResourceEntity]
          items = resource_entities.select { |link| link[:type] == "application/vnd.vmware.vcloud.vAppTemplate+xml" }
          items.each{|item| service.add_id_from_href!(item) }
          items
        end
      end
    end
  end
end
