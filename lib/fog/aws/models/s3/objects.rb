module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attr_accessor :is_truncated,
                      :marker,
                      :max_keys,
                      :prefix

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'IsTruncated' => :is_truncated,
            'Marker'      => :marker,
            'MaxKeys'     => :max_keys,
            'Prefix'      => :prefix
          })
          super
        end

        def [](key)
          self[key] ||= begin
            get(key)
          end
        end

        def all(options = {})
          options = {
            :is_truncated => is_trucated,
            :marker       => marker,
            :max_keys     => max_keys,
            :prefix       => prefix
          }.merge!(options)
          remap_attributes(options, {
            :is_truncated => 'IsTruncated',
            :marker       => 'Marker',
            :max_keys     => 'MaxKeys',
            :prefix       => 'Prefix'
          })
          bucket.buckets.get(bucket.name, options).objects
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
          object_data = { :body => data.body}
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
        end

        def head(key, options = {})
          data = connection.head_object(bucket.name, key, options)
          object_data = {}
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
        end

        def new(attributes = {})
          Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(attributes))
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

      end

    end
  end
end
