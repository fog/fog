require 'fog/core/model'
require 'fog/storage/models/local/files'

module Fog
  module Local
    class Storage

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
            Fog::Local::Storage::Files.new(
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
