module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attribute :options

        def all(options = {})
          merge_attributes(:options => options)
          bucket.buckets.get(bucket.name, @options).objects
        end

        def bucket
          @bucket
        end

        def create(attributes = {})
          object = new(attributes)
          object.save
          object
        end

        def get(key, options = {}, &block)
          data = connection.get_object(bucket.name, key, options, &block)
          object_data = {
            :body => data.body,
            :key  => key
          }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          object = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(object_data))
          object
        rescue Fog::Errors::NotFound
          nil
        end

        def get_url(key, expires)
          connection.get_object_url(bucket.name, key, expires)
        end

        def head(key, options = {})
          data = connection.head_object(bucket.name, key, options)
          object_data = {
            :key => key
          }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              object_data[key] = value
            end
          end
          object = Fog::AWS::S3::Object.new({
            :bucket     => bucket,
            :connection => connection,
            :objects    => self
          }.merge!(object_data))
          object
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
          all(@options)
        end

        private

        def bucket=(new_bucket)
          @bucket = new_bucket
        end

      end

    end
  end
end
