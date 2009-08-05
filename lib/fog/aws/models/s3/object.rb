module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attr_accessor :body, :content_length, :etag, :key, :last_modified, :owner, :size, :storage_class

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'Content-Length'  => :content_length,
            'ETag'            => :etag,
            'Key'             => :key,
            'LastModified'    => :last_modified,
            'Last-Modified'   => :last_modified,
            'Size'            => :size,
            'StorageClass'    => :storage_class
          })
          super
        end

        def copy(target_bucket_name, target_object_key)
          data = connection.copy_object(bucket, key, target_bucket_name, target_object_key).body
          copy = self.dup
          copy_data = {}
          for key, value in data
            if ['ETag', 'LastModified'].include?(key)
              copy_data[key] = value
            end
          end
          copy.update_attributes(copy_data)
          copy
        end

        def delete
          return false if new_record?
          connection.delete_object(bucket, key)
          @new_record = true
          true
        end

        def save(options = {})
          data = connection.put_object(bucket, key, body, options)
          @etag = data.headers['ETag']
          @new_record = false
          true
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

        def bucket
          @bucket
        end

      end

    end
  end
end
