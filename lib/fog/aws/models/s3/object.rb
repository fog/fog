module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attribute :body
        attribute :content_length,  'Content-Length'
        attribute :content_type,    'Content-Type'
        attribute :etag,            'Etag'
        attribute :key,             'Key'
        attribute :last_modified,   ['Last-Modified', 'LastModified']
        attribute :size,            'Size'
        attribute :storage_class,   'StorageClass'

        def initialize(attributes = {})
          super
        end

        def bucket
          @bucket
        end

        def copy(target_bucket_name, target_object_key)
          data = connection.copy_object(bucket.name, key, target_bucket_name, target_object_key).body
          target_bucket = connection.buckets.new(:name => target_bucket_name)
          target_object = target_bucket.objects.new(attributes)
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
