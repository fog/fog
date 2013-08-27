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
        
        def create(key,value)
          item_list unless @tags
          data = Fog::Generators::Compute::VcloudDirector::Metadata.new(@tags)
          data.add_item(key, value)
          response = service.post_vm_metadata(vm.id, data.attrs)
          service.process_task(response.body)
        end
        
#        private
        
        def item_list
          @tags = service.get_metadata(vm.id).body
          @items =[]
          @tags[:metadata].each_pair{ |k,v| @items << {:id => k, :value => v }.merge(:vm => vm) }
          @items
        end
        
        def get_by_id(item_id)
          item_list unless @items
          @items.detect{ |i| i[:id] == item_id}          
        end

        
      end
    end
  end
end
