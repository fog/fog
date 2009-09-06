module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attribute :body
        attribute :content_length,  'Content-Length'
        attribute :content_type,    'Content-Type'
        attribute :etag,            ['Etag', 'ETag']
        attribute :key,             'Key'
        attribute :last_modified,   ['Last-Modified', 'LastModified']
        attribute :owner
        attribute :size,            'Size'
        attribute :storage_class,   'StorageClass'

        def bucket
          @bucket
        end

        def copy(target_bucket_name, target_object_key)
          data = connection.copy_object(bucket.name, @key, target_bucket_name, target_object_key).body
          target_bucket = connection.buckets.new(:name => target_bucket_name)
          target_object = target_bucket.objects.new(attributes.merge!(:key => target_object_key))
          copy_data = {}
          for key, value in data
            if ['ETag', 'LastModified'].include?(key)
              copy_data[key] = value
            end
          end
          target_object.merge_attributes(copy_data)
          target_object
        end

        def destroy
          connection.delete_object(bucket.name, @key)
          true
        end

        def objects
          @objects
        end

        def reload
          new_attributes = objects.get(@key).attributes
          merge_attributes(new_attributes)
        end

        def save(options = {})
          data = connection.put_object(bucket.name, @key, @body, options)
          @etag = data.headers['ETag']
          true
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

        def objects=(new_objects)
          @objects = new_objects
        end

      end

    end
  end
end
