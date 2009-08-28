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

        def all(options = {})
          data = connection.get_bucket(bucket.name, options).body
          objects_data = {}
          for key, value in data
            if ['IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(key)
              objects_data[key] = value
            end
          end
          objects = Fog::AWS::S3::Objects.new({
            :bucket       => bucket,
            :connection   => connection
          }.merge!(objects_data))
          data['Contents'].each do |object|
            owner = Fog::AWS::S3::Owner.new(object.delete('Owner').merge!(:connection => connection))
            objects << Fog::AWS::S3::Object.new({
              :bucket     => bucket,
              :connection => connection,
              :owner      => owner
            }.merge!(object))
          end
          objects
        end

        def bucket
          @bucket
        end

        def create(attributes = {})
          object = new(attributes)
          object.save
          object
        end

        def get
          data = connection.get_object(bucket.name, key, options)
          object_data = { :body => data.body}
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection
          }.merge!(object_data))
        end

        def head
          data = connection.head_object(bucket.name, key, options)
          object_data = {}
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection
          }.merge!(object_data))
        end

        def new(attributes = {})
          Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection
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
