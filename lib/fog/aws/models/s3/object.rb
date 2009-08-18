module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attr_accessor :body,
          :content_length,
          :etag,
          :key,
          :last_modified,
          :owner,
          :size,
          :storage_class

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

        def body
          @body ||= get.body
        end

        def content_length
          @content_length ||= head.content_length
        end

        def copy(target_bucket_name, target_object_key)
          data = connection.copy_object(bucket.name, key, target_bucket_name, target_object_key).body
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
          connection.delete_object(bucket, key)
        end

        def etag
          @etag ||= head.etag
        end

        def last_modified
          @last_modified ||= head.last_modified
        end

        def save(options = {})
          data = connection.put_object(bucket.name, key, body, options)
          @etag = data.headers['ETag']
        end

        private

        def get
          data = connection.get_object(bucket.name, key, options)
          object_data = { :body => data.body}
          for key, value in data.headers
            if ['Content-Length', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          update_attributes(object_data)
        end

        def head
          data = connection.head_object(bucket.name, key, options)
          object_data = {}
          for key, value in data.headers
            if ['Content-Length', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          update_attributes(object_data)
        end

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
