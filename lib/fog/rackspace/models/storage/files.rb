require 'fog/collection'
require 'fog/rackspace/models/storage/file'

module Fog
  module Rackspace
    class Storage

      class Files < Fog::Collection

        attribute :directory
        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Rackspace::Storage::File

        def all(options = {})
          requires :directory
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

        def get(key, options = {}, &block)
          requires :directory
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
        rescue Fog::Rackspace::Storage::NotFound
          nil
        end

        def get_url(key, expires)
          requires :directory
          connection.get_object_url(directory.name, key, expires)
        end

        def head(key, options = {})
          requires :directory
          data = connection.head_object(directory.name, key, options)
          file_data = { :key => key }
          for key, value in data.headers
            if ['Content-Length', 'Content-Type', 'ETag', 'Last-Modified'].include?(key)
              file_data[key] = value
            end
          end
          new(file_data)
        rescue Fog::Rackspace::Storage::NotFound
          nil
        end

        def new(attributes = {})
          requires :directory
          super({ :directory => directory }.merge!(attributes))
        end

      end

    end
  end
end
