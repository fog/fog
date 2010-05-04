require 'fog/model'

module Fog
  module Local

    class File < Fog::Model

      identity  :key,             'Key'

      attr_accessor :body
      attribute :content_length,  'Content-Length'
      # attribute :content_type,    'Content-Type'
      attribute :last_modified,   'Last-Modified'

      def body
        @body ||= if last_modified
          collection.get(identity).body
        else
          ''
        end
      end

      def directory
        @directory
      end

      def destroy
        requires :directory, :key
        ::File.delete(path)
        true
      end

      def save(options = {})
        requires :body, :directory, :key
        file = ::File.new(path, 'w')
        file.write(body)
        file.close
        merge_attributes(
          :content_length => ::File.size(path),
          :last_modified  => ::File.mtime(path)
        )
        true
      end

      private

      def directory=(new_directory)
        @directory = new_directory
      end

      def path
        connection.path_to(::File.join(directory.key, key))
      end

    end

  end
end
