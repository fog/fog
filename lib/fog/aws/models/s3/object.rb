module Fog
  module AWS
    class S3

      class Object < Fog::Model

        identity  :key,             'Key'

        attribute :body
        attribute :content_length,  'Content-Length'
        attribute :content_type,    'Content-Type'
        attribute :etag,            ['Etag', 'ETag']
        attribute :last_modified,   ['Last-Modified', 'LastModified']
        attribute :owner,           'Owner'
        attribute :size,            'Size'
        attribute :storage_class,   'StorageClass'

        def bucket
          @bucket
        end

        def copy(target_bucket_name, target_object_key)
          requires :bucket, :key

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
          requires :bucket, :key

          connection.delete_object(bucket.name, @key)
          true
        end

        def owner=(new_owner)
          if new_owner
            @owner = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        def save(options = {})
          requires :body, :bucket, :key
          data = connection.put_object(bucket.name, @key, @body, options)
          @etag = data.headers['ETag']
          true
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

      end

    end
  end
end
