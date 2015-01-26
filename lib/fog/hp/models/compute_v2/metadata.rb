require 'fog/core/collection'
require 'fog/hp/models/compute_v2/meta_parent'
require 'fog/hp/models/compute_v2/meta'
require 'fog/hp/models/compute_v2/image'
require 'fog/hp/models/compute_v2/server'

module Fog
  module Compute
    class HPV2
      class Metadata < Fog::Collection
        model Fog::Compute::HPV2::Meta

        include Fog::Compute::HPV2::MetaParent

        def all
          requires :parent
          if @parent.id
            metadata = service.list_metadata(collection_name, @parent.id).body['metadata']
            metas = []
            metadata.each_pair {|k,v| metas << {'key' => k, 'value' => v} }
            load(metas)
          end
        end

        def destroy(key)
          requires :parent
          service.delete_meta(collection_name, @parent.id, key)
        rescue Fog::Compute::HPV2::NotFound
          nil
        end

        def get(key)
          requires :parent
          data = service.get_meta(collection_name, @parent.id, key).body["meta"]
          metas = []
          data.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          new(metas[0])
        rescue Fog::Compute::HPV2::NotFound
          nil
        end

        def new(attributes = {})
          requires :parent
          super({ :parent => @parent }.merge!(attributes))
        end

        def set(data=nil)
          requires :parent
          service.set_metadata(collection_name, @parent.id, meta_hash(data))
        end

        def update(data=nil)
          requires :parent
          service.update_metadata(collection_name, @parent.id, meta_hash(data))
        end

        private
        def meta_hash(data=nil)
          if data.nil?
            data={}
            self.each do |meta|
              if meta.is_a?(Fog::Compute::HPV2::Meta) then
                data.store(meta.key, meta.value)
              else
                data.store(meta['key'], meta['value'])
              end
            end
          end
          data
        end
      end
    end
  end
end
