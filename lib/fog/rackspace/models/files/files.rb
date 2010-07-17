require 'fog/collection'
require 'fog/rackspace/models/files/file'

module Fog
  module Rackspace
    module Files

      class Files < Fog::Collection

        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Rackspace::Files::File

        def all(options = {})
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            load(parent.files.map {|file| file.attributes})
          else
            nil
          end
        end

        def directory
          @directory
        end

        def get(key, options = {}, &block)
          options = {
            'limit'   => @limit,
            'marker'  => @marker,
            'path'    => @path,
            'prefix'  => @prefix
          }.merge!(options)
          data = connection.get_object(directory.name, key, options, &block)
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
          connection.get_object_url(directory.name, key, expires)
        end

        def head(key, options = {})
          data = connection.head_object(directory.name, key, options)
          file_data = { :key => key }
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
