require 'fog/core/collection'
require 'fog/atmos/models/storage/file'

module Fog
  module Storage
    class Atmos

      class Files < Fog::Collection

        attribute :directory
        attribute :limit
        attribute :marker
        attribute :path
        attribute :prefix

        model Fog::Storage::Atmos::File

        def all(options = {})
          requires :directory
          directory ? ns = directory.key : ns = ''
          ns = ns + '/' unless ns =~ /\/$/
          data = service.get_namespace(ns).body[:DirectoryList]
          data = {:DirectoryEntry => []} if data.kind_of? String
          data[:DirectoryEntry] = [data[:DirectoryEntry]] if data[:DirectoryEntry].kind_of? Hash
          files = data[:DirectoryEntry].select {|de| de[:FileType] == 'regular'}
          files.each do |s|
            data = service.head_namespace(directory.key + s[:Filename], :parse => false)
            headers = Hash[data.headers["x-emc-meta"].split(", ").collect{|s|s.split("=")}]
            s[:content_length] = data.headers["Content-Length"]
            s[:content_type] = data.headers["Content-Type"]
            s[:created_at] = headers["ctime"]
            s[:directory] = directory
          end
          # TODO - Load additional file meta?
          load(files)
        end

        def get(key, &block)
          requires :directory
          data = service.get_namespace(directory.key + key, :parse => false)#, &block)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key
          })
          new(file_data)
        rescue Fog::Storage::Atmos::NotFound
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
          data = service.head_namespace(directory.key + key, :parse => false)
          file_data = data.headers.merge({
            :body => data.body,
            :key => key
          })
          new(file_data)
        rescue Fog::Storage::Atmos::NotFound
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
