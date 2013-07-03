require 'fog/core/collection'
require 'fog/vcloudng/models/compute/tag'

module Fog
  module Compute
    class Vcloudng

      class Tags < Fog::Collection
        model Fog::Compute::Vcloudng::Tag
        
        attribute :vm_id
        
        def index
          tags.keys.map{ |key| new({key: key, value: tags[key] }.merge(vm_id: vm_id))}
        end 
        
        def all
          index
        end

        def get(tag_id)
          tag = tags.detect{ |tag| tag.keys.first == tag_id }
          return nil unless tag
          new(tag.merge(vm_id: vm_id))
        end
        
        def create(key,value)
          tags unless @tags
          data = Fog::Generators::Compute::Vcloudng::Metadata.new(@tags)
          data.add_item(key,value)
          response = service.post_vm_metadata(vm_id, data.attrs)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:crate_tag_task] = service.tasks.new(task)
        end
        
#        private
        
        def tags
          @tags = service.get_vm_metadata(vm_id).body
          @tags[:metadata]
        end
        
      end
    end
  end
end
