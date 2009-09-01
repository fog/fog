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
          bucket.buckets.get(bucket.name, attributes).objects
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
          if self[key] && self[key].body
            self[key]
          else
            self[key] ||= begin
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
            rescue Fog::Errors::NotFound
              nil
            end
          end
        end

        def head(key, options = {})
          self[key] ||= begin
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
          rescue Fog::Errors::NotFound
            nil
          end
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
