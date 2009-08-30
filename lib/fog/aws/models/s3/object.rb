module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attr_accessor :body,
                      :content_length,
                      :content_type,
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

        def bucket
          @bucket
        end

        def copy(target_bucket_name, target_object_key)
          data = connection.copy_object(bucket.name, key, target_bucket_name, target_object_key).body
          target_bucket = connection.buckets.new(:name => target_bucket_name)
          target_object = target_bucket.objects.new(
            :body           => body,
            :content_length => content_length,
            :content_type   => content_type,
            :etag           => etag,
            :key            => key,
            :last_modified  => last_modified,
            :owner          => owner,
            :size           => size,
            :storage_class  => storage_class
          )
          copy_data = {}
          for key, value in data
            if ['ETag', 'LastModified'].include?(key)
              copy_data[key] = value
            end
          end
          target_object.merge_attributes(copy_data)
        end

        def destroy
          connection.delete_object(bucket, key)
          objects.delete(key)
          true
        end

        def new_record?
          objects.key?(key)
        end

        def reload
          objects.get(key)
        end

        def save(options = {})
          data = connection.put_object(bucket.name, key, body, options)
          @etag = data.headers['ETag']
          objects[key] = self
          true
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

        def objects
          @objects
        end

        def objects=(new_objects)
          @objects = new_objects
        end

      end

    end
  end
end
