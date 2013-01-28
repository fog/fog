require 'fog/core/collection'
require 'fog/openstack/models/storage/file'

module Fog
  module Storage
    class OpenStack

      class Files < Fog::Collection

        attribute :directory
        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Storage::OpenStack::File

        def all(options = {})
          requires :directory
          options = {
            'limit'   => limit,
            'marker'  => marker,
            'path'    => path,
            'prefix'  => prefix
          }.merge!(options)
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

        alias :each_file_this_page :each
        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each_file_this_page {|f| yield f}
            while subset.length == (subset.limit || 10000)
              subset = subset.all(:marker => subset.last.key)
              subset.each_file_this_page {|f| yield f}
            end

            self
          end
        end

        def get(key, &block)
          requires :directory
          data = service.get_object(directory.key, key, &block)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key
          })
          new(file_data)
        rescue Fog::Storage::OpenStack::NotFound
          nil
        end

        def get_url(key)
          requires :directory
          if self.directory.public_url
            "#{self.directory.public_url}/#{Fog::OpenStack.escape(key, '/')}"
          end
        end

        def head(key, options = {})
          requires :directory
          data = service.head_object(directory.key, key)
          file_data = data.headers.merge({
            :key => key
          })
          new(file_data)
        rescue Fog::Storage::OpenStack::NotFound
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
