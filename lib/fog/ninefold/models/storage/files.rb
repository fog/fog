require 'fog/core/collection'
require 'fog/ninefold/models/storage/file'

module Fog
  module Storage
    class Ninefold

      class Files < Fog::Collection

        attribute :directory
        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Storage::Ninefold::File

        def all(options = {})
          requires :directory
          directory ? ns = directory.key : ns = ''
          ns = ns + '/' unless ns =~ /\/$/
          data = connection.get_namespace(ns).body[:DirectoryList]
          data = {:DirectoryEntry => []} if data.kind_of? String
          data[:DirectoryEntry] = [data[:DirectoryEntry]] if data[:DirectoryEntry].kind_of? Hash
          files = data[:DirectoryEntry].select {|de| de[:FileType] == 'regular'}
          files.each do |s|
            s[:directory] = directory
          end
          # TODO - Load additional file meta?
          load(files)
        end

        def get(key, &block)
          requires :directory
          data = connection.get_namespace(directory.key + key, :parse => false)#, &block)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key
          })
          new(file_data)
        rescue Fog::Storage::Ninefold::NotFound
          nil
        end

        def get_url(key)
          requires :directory
          if self.directory.public_url
            "#{self.directory.public_url}/#{key}"
          end
        end

        def head(key, options = {})
          requires :directory
          data = connection.head_object(directory.key, key)
          file_data = data.headers.merge({
            :key => key
          })
          new(file_data)
        rescue Fog::Storage::Rackspace::NotFound
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
