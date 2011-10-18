require 'fog/core/model'
require 'fog/local/models/storage/files'

module Fog
  module Storage
    class Local

      class Directory < Fog::Model

        identity  :key

        def destroy
          requires :key

          if ::File.directory?(path)
            Dir.rmdir(path)
            true
          else
            false
          end
        end

        def files
          @files ||= begin
            Fog::Storage::Local::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def public=(new_public)
          new_public
        end

        def public_url
          nil
        end

        def save
          requires :key

          Dir.mkdir(path)
          true
        end

        private

        def path
          connection.path_to(key)
        end

      end

    end
  end
end
