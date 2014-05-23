require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/tag'

module Fog
  module Compute
    class VcloudDirector
      class Tags < Collection
        model Fog::Compute::VcloudDirector::Tag

        attribute :vm

        def get_by_name(tag_name)
          get(tag_name)
        end

        def get_by_id(item_id)
          item_list unless @items
          @items.find{ |i| i[:id] == item_id}
        end

        def create(key,value)
          response = service.post_update_vapp_metadata(vm.id, { key => value} )
          service.process_task(response.body)
        end

        def hash_items
          @tags = service.get_metadata(vm.id).body
          @tags[:metadata]
        end

        private

        def item_list
          @items =[]
          hash_items.each_pair{ |k,v| @items << {:id => k, :value => v }.merge(:vm => vm) }
          @items
        end
      end
    end
  end
end
