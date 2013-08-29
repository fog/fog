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
          metadata_klass = case service.api_version
                           when '5.1' ; Fog::Generators::Compute::VcloudDirector::MetadataV51
                           when '1.5' ; Fog::Generators::Compute::VcloudDirector::MetadataV15
                           else raise "API version: #{api_version} not supported"
                           end
          data = metadata_klass.new(@tags)
          data.add_item(key, value)
          response = service.post_vm_metadata(vm.id, data.attrs)
          service.process_task(response.body)
        end
        
        def hash_items
          @tags = service.get_metadata(vm.id).body
          @tags[:metadata]
        end
        
#        private
        
        def item_list
          @items =[]
          hash_items.each_pair{ |k,v| @items << {:id => k, :value => v }.merge(:vm => vm) }
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
