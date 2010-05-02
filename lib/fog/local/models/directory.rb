require 'fog/model'
# require 'fog/local/models/files'

module Fog
  module Local

    class Directory < Fog::Model

      identity  :name

      def destroy
        requires :name

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
        requires :name

        Dir.mkdir(path)
        true
      end

      private

      def path
        connection.path_to(name)
      end

    end

  end
end
