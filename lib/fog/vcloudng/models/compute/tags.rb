require 'fog/core/collection'
require 'fog/vcloudng/models/compute/tag'

module Fog
  module Compute
    class Vcloudng

      class Tags < Collection
        model Fog::Compute::Vcloudng::Tag
        
        attribute :vm
        
#        def index
#          tags.keys.map{ |key| new({key: key, value: tags[key] }.merge(vm: vm)) }
#        end 
#        
#        def all
#          index
#        end
#
#        def get(tag_id)
#          return nil unless tags[tag_id]
#          new({key: tag_id, value: tags[tag_id] }.merge(vm: vm))
#        end
        
        def get_by_name(tag_name)
          get(tag_name)
        end
        
        def create(key,value)
          item_list unless @tags
          data = Fog::Generators::Compute::Vcloudng::Metadata.new(@tags)
          data.add_item(key, value)
          response = service.post_vm_metadata(vm.id, data.attrs)
          service.process_task(response.body)
        end
        
#        private
        
        def item_list
          @tags = service.get_vm_metadata(vm.id).body
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
