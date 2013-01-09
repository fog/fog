require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/meta_parent'
require 'fog/rackspace/models/compute_v2/metadatum'
require 'fog/rackspace/models/compute_v2/image'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Compute
    class RackspaceV2

      class Metadata < Fog::Collection

        model Fog::Compute::RackspaceV2::Metadatum

        include Fog::Compute::RackspaceV2::MetaParent

        def all
          requires :parent
          data = connection.list_metadata(collection_name, parent.id).body['metadata']
          from_hash(data)
        end

        def get(key)
          requires :parent
          data = connection.get_metadata_item(collection_name, parent.id, key).body["meta"]          
          datum = data.first
          new(:key => datum[0], :value => datum[1])
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
        
        def [](key)
          return super(key) if key.is_a?(Integer)
          return nil unless key
          datum = self.find {|datum| datum.key == key || datum.key == key.to_sym }
          datum ? datum.value : nil
        end
        
        def []=(key, value)
          return super(key,value) if key.is_a?(Integer)          
          return nil unless key
          datum = self.find {|datum| datum.key == key || datum.key == key.to_sym }
          if datum
            data.value = value
          else
            self << Fog::Compute::RackspaceV2::Metadatum.new(:key => key, :value => value, :connection => connection, :parent => parent)
          end
          value
        end
        
        def save
          requires :parent
          connection.set_metadata(collection_name, parent.id, to_hash)          
        end

        def new(attributes = {})
          requires :parent
          super({ :parent => parent }.merge!(attributes))
        end

        def from_hash(hash)
          return unless hash
          metas = []
          hash.each_pair {|k,v| metas << {:key => k, :value => v} }
          load(metas)
        end
        
        def to_hash
          h = {}
          self.each { |datum| h[datum.key] = datum.value }
          h
        end

      end
    end
  end
end
