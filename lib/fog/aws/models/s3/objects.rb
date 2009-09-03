module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attribute :is_truncated,  'IsTruncated'
        attribute :marker,        'Marker'
        attribute :max_keys,      'MaxKeys'
        attribute :prefix,        'Prefix'

        def initialize(attributes = {})
          super
        end

        def all(options = {})
          merge_attributes(options)
          self.delete_if {true}
          objects = bucket.buckets.get(bucket.name, attributes).objects
          objects.keys.each do |key|
            self[key] = objects[key]
          end
          self
        end

        def bucket
          @bucket
        end

        def create(attributes = {})
          object = new(attributes)
          object.save
          object
        end

        def get(key, options = {})
          data = connection.get_object(bucket.name, key, options)
          object_data = {
            :body => data.body,
            :key  => key
          }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          self[object_data['key']] = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(object_data))
        rescue Fog::Errors::NotFound
          nil
        end

        def head(key, options = {})
          data = connection.head_object(bucket.name, key, options)
          object_data = {
            :key => key
          }
          for key, value in data.headers
            if ['Content-Length', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          self[object_data['key']] = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(object_data))
        rescue Fog::Errors::NotFound
          nil
        end

        def new(attributes = {})
          Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(attributes))
        end

        def reload
          all
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

      end

    end
  end
end
