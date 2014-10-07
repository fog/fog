module Fog
  module Storage
    class Rackspace
      class Metadata
        OBJECT_META_PREFIX = "X-Object-Meta-"
        OBJECT_REMOVE_META_PREFIX = "X-Remove-Object-Meta-"
        CONTAINER_META_PREFIX = "X-Container-Meta-"
        CONTAINER_REMOVE_META_PREFIX = "X-Remove-Container-Meta-"

        # Cloud Files will ignore headers without a value
        DUMMY_VALUE = 1

        CONTAINER_KEY_REGEX = /^#{CONTAINER_META_PREFIX}(.*)/
        OBJECT_KEY_REGEX = /^#{OBJECT_META_PREFIX}(.*)/

        # @!attribute [rw] data
        # @return [Hash] underlying data store for metadata class
        attr_reader :data

        # @!attribute [rw] parent
        # @return [Fog::Storage::Rackspace::Directory,Fog::Storage::Rackspace::File] the parent object of the metadata
        attr_reader :parent

        # Initialize
        # @param [Fog::Storage::Rackspace::Directory,Fog::Storage::Rackspace::File] parent object of the metadata
        # @param [Hash] hash containing initial metadata values
        def initialize(parent, hash={})
          @data = hash || {}
          @deleted_hash = {}
          @parent = parent
        end

        # Delete key value pair from metadata
        # @param [String] key to be deleted
        # @return [Object] returns value for key
        # @note Metadata must be deleted using this method in order to properly remove it from Cloud Files
        def delete(key)
          data.delete(key)
          @deleted_hash[key] = nil
        end

        # Returns metadata in a format expected by Cloud Files
        # @return [Hash] Metadata in a format expected by Cloud Files
        def to_headers
          headers = {}
          h = data.merge(@deleted_hash)
          h.each_pair do |k,v|
            key = to_header_key(k,v)
            headers[key] = v || DUMMY_VALUE
          end

          headers
        end

        # Retrieve specific value for key from Metadata.
        # * If key is of type String, this method will return the value of the metadatum
        # @param [#key] key
        # @return [#value]
        def [](key)
          return nil unless key
          @data[key.to_s] || @data[key.to_sym]
        end

        # Set value for key.
        # * If key is of type String, this method will set/add the value to Metadata
        # @param [#key] key
        # @return [String]
        def []=(key, value)
          return nil unless key
          if @data[key.to_s]
            @data[key.to_s] = value
          elsif @data[key.to_sym]
            @data[key.to_sym] = value
          else
            @data[key] = value
          end
        end

        # Creates metadata object from Cloud File Headers
        # @param [Fog::Storage::Rackspace::Directory,Fog::Storage::Rackspace::File] parent object of the metadata
        # @param [Hash] headers Cloud File headers
        def self.from_headers(parent, headers)
          metadata = Metadata.new(parent)
          headers.each_pair do |k, v|
            key = metadata.send(:to_key, k)
            next unless key
            metadata.data[key] = v
          end
          metadata
        end

        # Returns true if method is implemented by Metadata class
        # @param [Symbol] method_sym
        # @param [Boolean] include_private
        def respond_to?(method_sym, include_private = false)
          super(method_sym, include_private) || data.respond_to?(method_sym, include_private)
        end

        # Invoked by Ruby when obj is sent a message it cannot handle.
        def method_missing(method, *args, &block)
          data.send(method, *args, &block)
        end

        private

        def directory?
          [Fog::Storage::Rackspace::Directory, Fog::Storage::Rackspace::Directories].include? parent_class
        end

        def file?
          [Fog::Storage::Rackspace::File, Fog::Storage::Rackspace::Files].include? parent_class
        end

        def parent_class
          parent.is_a?(Class) ? parent : parent.class
        end

        def meta_prefix
          if directory?
            CONTAINER_META_PREFIX
          elsif file?
            OBJECT_META_PREFIX
          else
            raise "Metadata prefix is unknown for #{parent_class}"
          end
        end

        def remove_meta_prefix
          if directory?
            CONTAINER_REMOVE_META_PREFIX
          elsif file?
            OBJECT_REMOVE_META_PREFIX
          else
            raise "Remove Metadata prefix is unknown for #{parent_class}"
          end
        end

        def meta_prefix_regex
          if directory?
            CONTAINER_KEY_REGEX
          elsif file?
            OBJECT_KEY_REGEX
          else
            raise "Metadata prefix is unknown for #{parent_class}"
          end
        end

        def to_key(key)
           m = key.match meta_prefix_regex
           return nil unless m && m[1]

           a = m[1].split('-')
           a.map!(&:downcase)
           str = a.join('_')
           str.to_sym
         end

        def to_header_key(key, value)
          prefix = value.nil? ?  remove_meta_prefix : meta_prefix
          prefix + key.to_s.split(/[-_]/).map(&:capitalize).join('-')
        end
      end
    end
  end
end
