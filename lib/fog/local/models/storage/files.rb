require 'fog/core/collection'
require 'fog/local/models/storage/file'

module Fog
  module Storage
    class Local

      class Files < Fog::Collection

        attribute :directory

        model Fog::Storage::Local::File

        def all
          requires :directory
          if directory.collection.get(directory.key)
            data = []
            Dir.chdir(service.path_to(directory.key)) {
              data = Dir.glob('**/*').reject do |file|
                ::File.directory?(file)
              end.map do |key|
                path = file_path(key)
                {
                  :content_length => ::File.size(path),
                  :key            => key,
                  :last_modified  => ::File.mtime(path)
                }
              end
            }
            load(data)
          else
            nil
          end
        end

        def get(key, &block)
          requires :directory
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
              body = ::File.read(path)
              new(data.merge!(:body => body))
            end
          else
            nil
          end
        end

        def head(key)
          requires :directory
          path = file_path(key)
          if ::File.exists?(path)
            new({
              :content_length => ::File.size(path),
              :key            => key,
              :last_modified  => ::File.mtime(path)
            })
          else
            nil
          end
        end

        def new(attributes = {})
          requires :directory
          super({ :directory => directory }.merge!(attributes))
        end

        private

        def file_path(key)
          service.path_to(::File.join(directory.key, key))
        end

      end
    end
  end
end
