module Fog
  module Storage
    class Rackspace
      
      class Metadata
        
        # META_PREFIX = "X-Object-Meta-"
        # REMOVE_META_PREFIX = "X-Remove-Object-Meta-"
        META_PREFIX = "X-Container-Meta-"
        REMOVE_META_PREFIX = "X-Remove-Container-Meta-"
        
        # Cloud Files will ignore headers without a value
        DUMMY_VALUE = 1
        
        KEY_REGEX = /^#{META_PREFIX}(.*)/
        
        attr_reader :data
        
        def initialize(hash={})
          @data = hash || {}
          @deleted_hash = {}
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
        
        def self.from_headers(headers)
          metadata = Metadata.new
          headers.each_pair do |k, v|
            key = Metadata.to_key(k)
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
        
        def self.to_key(key)
           m = key.match KEY_REGEX
           return nil unless m && m[1]
           
           a = m[1].split('-')
           a.collect!(&:downcase)
           str = a.join('_')
           str.to_sym
         end
                 
        def to_header_key(key, value)
          prefix = value.nil? ?  REMOVE_META_PREFIX : META_PREFIX
          prefix + key.to_s.split(/[-_]/).collect(&:capitalize).join('-')
        end
        
      end
      
    end
  end
end