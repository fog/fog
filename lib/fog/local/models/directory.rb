require 'fog/model'
# require 'fog/local/models/files'

module Fog
  module Local

    class Directory < Fog::Model
      extend Fog::Deprecation
      deprecate(:name, :key)
      deprecate(:name=, :key=)

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
          Fog::Local::Files.new(
            :directory    => self,
            :connection   => connection
          )
        end
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
