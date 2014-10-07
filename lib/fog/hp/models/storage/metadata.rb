require 'fog/core/collection'
require 'fog/hp/models/storage/meta_parent'
require 'fog/hp/models/storage/meta'

module Fog
  module Storage
    class HP
      class Metadata < Fog::Collection
        model Fog::Storage::HP::Meta

        include Fog::Storage::HP::MetaParent

        def all
          requires :parent
          if @parent.key
            metadata = service.head_container(@parent.key).headers
            metas = []
            metadata.each_pair {|k,v| metas << {'key' => k, 'value' => v} }
            load(metas)
          end
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def destroy
          false
        end

        def get(key)
          requires :parent
          if @parent.key
            metadata = service.head_container(@parent.key).headers
            metas = []
            metas << {'key' => key, 'value' => metadata[key]}
            new(metas[0])
          end
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def new(attributes = {})
          requires :parent
          super({ :parent => @parent }.merge!(attributes))
        end

        def set(data=nil)
          requires :parent
          if @parent.key
            service.put_container(@parent.key, meta_hash(data))
          end
        end

        def update(data=nil)
          requires :parent
          if @parent.key
            service.post_container(@parent.key, meta_hash(data))
          end
        end

        private
        def meta_hash(data=nil)
          if data.nil?
            data={}
            self.each do |meta|
              if meta.is_a?(Fog::Storage::HP::Meta) then
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
