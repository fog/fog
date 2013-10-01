require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/media'

module Fog
  module Compute
    class VcloudDirector

      class Medias < Collection
        model Fog::Compute::VcloudDirector::Media

        attribute :vdc

        private

        def get_by_id(item_id)
          item = service.get_media(item_id).body
          %w(:Link).each {|key_to_delete| item.delete(key_to_delete)}
          service.add_id_from_href!(item)
          item
        end

        def item_list
          data = service.get_vdc(vdc.id).body
          return [] if data[:ResourceEntities].empty?
          items = ensure_list(data[:ResourceEntities][:ResourceEntity]).select do |resource|
            resource[:type] == 'application/vnd.vmware.vcloud.media+xml'
          end
          items.each {|item| service.add_id_from_href!(item)}
          items
        end

      end
    end
  end
end
