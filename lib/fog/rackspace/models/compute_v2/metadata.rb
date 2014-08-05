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

        # Retrieves all of the metadata from server
        # @return [Fog::Compute::RackspaceV2::Metadatum] list of metadatum
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def all
          requires :parent
          return unless parent.identity
          data = service.list_metadata(collection_name, parent.id).body['metadata']
          from_hash(data)
        end

        # Retrieves specific metadata from server
        # @param [String] key for metadatum
        # @return [Fog::Compute::RackspaceV2::Metadatum] metadatum
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def get(key)
          requires :parent
          data = service.get_metadata_item(collection_name, parent.id, key).body["meta"]
          datum = data.first
          new(:key => datum[0], :value => datum[1])
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end

        # Retrieve specific value for key from Metadata.
        # * If key is of type String, this method will return the value of the metadatum
        # * If key is of type Fixnum, this method will return a Fog::Compute::RackspaceV2::Metadatum object (legacy)
        # @param [#key] key
        # @return [#value]
        def [](key)
          return super(key) if key.is_a?(Integer)
          return nil unless key
          datum = self.find {|datum| datum.key == key || datum.key == key.to_sym }
          datum ? datum.value : nil
        end

        # Set value for key.
        # * If key is of type String, this method will set/add the value to Metadata
        # * If key is of type Fixnum, this method will set a Fog::Compute::RackspaceV2::Metadatum object (legacy)
        # @param [#key] key
        # @return [String]
        def []=(key, value)
          return super(key,value) if key.is_a?(Integer)
          return nil unless key
          datum = self.find {|datum| datum.key == key || datum.key == key.to_sym }
          if datum
            datum.value = value
          else
            self << Fog::Compute::RackspaceV2::Metadatum.new(:key => key, :value => value, :service => service, :parent => parent)
          end
          value
        end

        # Saves the current metadata on server
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def save
          requires :parent
          service.set_metadata(collection_name, parent.id, to_hash)
        end

        # Creates new metadata
        def new(attributes = {})
          super({ :parent => parent }.merge!(attributes))
        end

        # Resets metadata using data from hash
        # @param hash hash containing key value pairs used to populate metadata.
        # @note This will remove existing data
        def from_hash(hash)
          return unless hash
          metas = []
          hash.each_pair {|k,v| metas << {:key => k, :value => v} }
          load(metas)
        end

        # Converts metadata object to hash
        # @return [Hash] hash of metadata key value pairs
        def to_hash
          h = {}
          self.each { |datum| h[datum.key] = datum.value }
          h
        end
      end
    end
  end
end
