require 'fog/core/collection'
require 'fog/vcloudng/models/compute/tag'

module Fog
  module Compute
    class Vcloudng

      class Tags < Fog::Collection
        model Fog::Compute::Vcloudng::Tag
        
        attribute :vm_id
        
        def index
          tags.keys.map{ |key| new({key: key, value: tags[key] }.merge(vm_id: vm_id)) }
        end 
        
        def all
          index
        end

        def get(tag_id)
          return nil unless tags[tag_id]
          new({key: tag_id, value: tags[tag_id] }.merge(vm_id: vm_id))
        end
        
        def create(key,value)
          tags unless @tags
          data = Fog::Generators::Compute::Vcloudng::Metadata.new(@tags)
          data.add_item(key,value)
          response = service.post_vm_metadata(vm_id, data.attrs)
          service.process_task(response.body)
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
