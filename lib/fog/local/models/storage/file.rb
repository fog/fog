require 'fileutils'
require 'fog/core/model'

module Fog
  module Storage
    class Local

      class File < Fog::Model

        identity  :key,             :aliases => 'Key'

        attribute :content_length,  :aliases => 'Content-Length', :type => :integer
        # attribute :content_type,    :aliases => 'Content-Type'
        attribute :last_modified,   :aliases => 'Last-Modified'

        require 'uri'

        def body
          attributes[:body] ||= if last_modified
            collection.get(identity).body
          else
            ''
          end
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        def content_type
          @content_type ||= begin
            unless (mime_types = ::MIME::Types.of(key)).empty?
              mime_types.first.content_type
            end
          end
        end

        def directory
          @directory
        end

        def copy(target_directory_key, target_file_key, options={})
          requires :directory, :key
          service.copy_object(directory.key, key, target_directory_key, target_file_key)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        def destroy
          requires :directory, :key
          ::File.delete(path) if ::File.exists?(path)
          dirs = path.split(::File::SEPARATOR)[0...-1]
          dirs.length.times do |index|
            dir_path = dirs[0..-index].join(::File::SEPARATOR)
            if dir_path.empty? # path starts with ::File::SEPARATOR
              next
            end
            # don't delete the containing directory or higher
            if dir_path == service.path_to(directory.key)
              break
            end
            pwd = Dir.pwd
            if ::File.exists?(dir_path) && ::File.directory?(dir_path)
              Dir.chdir(dir_path)
              if Dir.glob('*').empty?
                Dir.rmdir(dir_path)
              end
              Dir.chdir(pwd)
            end
          end
          true
        end

        def public=(new_public)
          new_public
        end

        def public_url
          requires :directory, :key

          if service.endpoint
            escaped_directory = URI.escape(directory.key)
            escaped_key = URI.escape(key)

            ::File.join(service.endpoint, escaped_directory, escaped_key)
          else
            nil
          end
        end

        def save(options = {})
          requires :body, :directory, :key
          dirs = path.split(::File::SEPARATOR)[0...-1]
          dirs.length.times do |index|
            dir_path = dirs[0..index].join(::File::SEPARATOR)
            if dir_path.empty? # path starts with ::File::SEPARATOR
              next
            end
            # create directory if it doesn't already exist
            unless ::File.directory?(dir_path)
              Dir.mkdir(dir_path)
            end
          end
          file = ::File.new(path, 'wb')
          if body.is_a?(String)
            file.write(body)
          elsif body.kind_of? ::File and ::File.exists?(body.path)
            FileUtils.cp(body.path, path)
          else
            file.write(body.read)
          end
          file.close
          merge_attributes(
            :content_length => Fog::Storage.get_body_size(body),
            :last_modified  => ::File.mtime(path)
          )
          true
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

        def path
          service.path_to(::File.join(directory.key, key))
        end

      end

    end
  end
end
