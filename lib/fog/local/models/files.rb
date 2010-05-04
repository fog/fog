require 'fog/collection'
require 'fog/local/models/file'

module Fog
  module Local

    class Files < Fog::Collection

      model Fog::Local::File

      def all
        if directory.collection.get(directory.key)
          data = Dir.entries(connection.path_to(directory.key)).select do |key|
            key[0...1] != '.' && !::File.directory?(connection.path_to(key))
          end.map do |key|
            path = file_path(key)
            {
              :content_length => ::File.size(path),
              :key            => key,
              :last_modified  => ::File.mtime(path)
            }
          end
          load(data)
        else
          nil
        end
      end

      def directory
        @directory
      end

      def get(key, &block)
        path = file_path(key)
        if ::File.exists?(path)
          data = {
            :content_length => ::File.size(path),
            :key            => key,
            :last_modified  => ::File.mtime(path)
          }
          if block_given?
            file = ::File.open(path)
            while (chunk = file.read(Excon::CHUNK_SIZE)) && yield(chunk); end
            file.close
            new(data)
          else
            body = nil
            ::File.open(path) do |file|
              body = file.read
            end
            new(data.merge!(:body => body))
          end
        else
          nil
        end
      end

      def new(attributes = {})
        super({ :directory => directory }.merge!(attributes))
      end

      private

      def directory=(new_directory)
        @directory = new_directory
      end

      def file_path(key)
        connection.path_to(::File.join(directory.key, key))
      end

    end
  end
end
