require 'fog/openstack/models/collection'
require 'fog/openstack/models/meta_parent'
require 'fog/openstack/models/compute/metadatum'
require 'fog/openstack/models/compute/image'
require 'fog/openstack/models/compute/server'

module Fog
  module Compute
    class OpenStack
      class Metadata < Fog::OpenStack::Collection
        model Fog::Compute::OpenStack::Metadatum

        include Fog::Compute::OpenStack::MetaParent

        def all
          requires :parent
          metadata = service.list_metadata(collection_name, @parent.id).body['metadata']
          metas = []
          metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} } unless metadata.nil?
          # TODO convert to load_response?
          load(metas)
        end

        def get(key)
          requires :parent
          data = service.get_metadata(collection_name, @parent.id, key).body["meta"]
          metas = []
          data.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          new(metas[0])
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end

        def update(data=nil)
          requires :parent
          service.update_metadata(collection_name, @parent.id, to_hash(data))
        end

        def set(data=nil)
          requires :parent
          service.set_metadata(collection_name, @parent.id, to_hash(data))
        end

        def new(attributes = {})
          requires :parent
          super({ :parent => @parent }.merge!(attributes))
        end

        def to_hash(data=nil)
          if data.nil?
            data={}
            self.each do |meta|
              if meta.is_a?(Fog::Compute::OpenStack::Metadatum) then
                data.store(meta.key, meta.value)
              else
                data.store(meta["key"], meta["value"])
              end
            end
          end
          data
        end
      end
    end
  end
end
