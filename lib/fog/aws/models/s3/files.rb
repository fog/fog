require 'fog/collection'
require 'fog/aws/models/s3/file'

module Fog
  module AWS
    class S3

      class Files < Fog::Collection

        attribute :delimiter,     :aliases => 'Delimiter'
        attribute :directory
        attribute :is_truncated,  :aliases => 'IsTruncated'
        attribute :marker,        :aliases => 'Marker'
        attribute :max_keys,      :aliases => ['MaxKeys', 'max-keys']
        attribute :prefix,        :aliases => 'Prefix'

        model Fog::AWS::S3::File

        def all(options = {})
          requires :directory
          options = {
            'delimiter'   => @delimiter,
            'marker'      => @marker,
            'max-keys'    => @max_keys,
            'prefix'      => @prefix
          }.merge!(options)
          options = options.reject {|key,value| value.nil? || value.to_s.empty?}
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            merge_attributes(parent.files.attributes)
            load(parent.files.map {|file| file.attributes})
          else
            nil
          end
        end

        def get(key, options = {}, &block)
          requires :directory
          data = connection.get_object(directory.key, key, options, &block)
          file_data = {
            :body => data.body,
            :key  => key
          }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              file_data[key] = value
            end
          end
          new(file_data)
        rescue Excon::Errors::NotFound
          nil
        end

        def get_url(key, expires)
          requires :directory
          connection.get_object_url(directory.key, key, expires)
        end

        def head(key, options = {})
          requires :directory
          data = connection.head_object(directory.key, key, options)
          file_data = {
            :key => key
          }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              file_data[key] = value
            end
          end
          new(file_data)
        rescue Excon::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :directory
          super({ :directory => directory }.merge!(attributes))
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

      end

    end
  end
end
