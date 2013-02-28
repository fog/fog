require 'fog/rackspace/models/storage/directory'
require 'fog/rackspace/models/storage/file'
require 'fog/rackspace/models/storage/directories'
require 'fog/rackspace/models/storage/files'

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
        
        
        attr_reader :data, :parent
        
        def initialize(parent, hash={})
          @data = hash || {}
          @deleted_hash = {}
          @parent = parent
        end
                
        def delete(key)
          data.delete(key)
          @deleted_hash[key] = nil
        end
                
        def to_headers
          headers = {}          
          h = data.merge(@deleted_hash) 
          h.each_pair do |k,v|
            key = to_header_key(k,v)
            headers[key] = v || DUMMY_VALUE 
          end
          
          headers
        end
        
        def self.from_headers(parent, headers)
          metadata = Metadata.new(parent)
          headers.each_pair do |k, v|
            key = metadata.send(:to_key, k)
            next unless key
            metadata.data[key] = v
          end
          metadata
        end   
        
        def respond_to?(method_sym, include_private = false)
          super(method_sym, include_private) || data.respond_to?(method_sym, include_private)
        end
                
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
           a.collect!(&:downcase)
           str = a.join('_')
           str.to_sym
         end
                 
        def to_header_key(key, value)
          prefix = value.nil? ?  remove_meta_prefix : meta_prefix
          prefix + key.to_s.split(/[-_]/).collect(&:capitalize).join('-')
        end
        
      end
      
    end
  end
end