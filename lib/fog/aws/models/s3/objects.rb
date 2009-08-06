module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attr_accessor :is_truncated, :marker, :max_keys, :prefix

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'IsTruncated' => :is_truncated,
            'Marker' => :marker,
            'MaxKeys' => :max_keys,
            'Prefix' => :prefix
          })
          super
        end

        def create(attributes = {})
          object = new(attributes)
          object.save
          object
        end

        def get(key, options = {})
          data = connection.get_object(bucket.name, key, options)
          object_data = {}
          for key, value in data.headers
            if ['Content-Length', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          object = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :body       => data.body,
            :connection => connection
          }.merge!(object_data))
        end

        def head(key, options = {})
          data = connection.head_object(bucket.name, key, options)
          object_data = {}
          for key, value in data.headers
            if ['Content-Length', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          object = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection
          }.merge!(object_data))
        end

        def new(attributes = {})
          Fog::AWS::S3::Object.new(attributes.merge!(:connection => connection))
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
