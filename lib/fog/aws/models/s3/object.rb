module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attr_accessor :etag, :key, :last_modified, :owner, :size, :storage_class

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'ETag'          => :etag,
            'Key'           => :key,
            'LastModified'  => :last_modified,
            'Size'          => :size,
            'StorageClass'  => :storage_class
          })
          super
        end

      end

    end
  end
end
