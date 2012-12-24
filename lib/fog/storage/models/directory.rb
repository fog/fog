require 'fog/core/model'

module Fog
  module Storage
    class Directory < Fog::Model
      identity  :key, :aliases => ['Name', 'name']

      # TODO: support for versioned buckets
      def clear_directory
        self.files.each do |file|
          return false if !file.destroy
        end
        true
      end

      def destroy(opts = {})
        requires :key
        if opts[:recursive]
          return false if !self.clear_directory
          if self.respond_to?('directories')
            self.directories.each do |dir|
              dir.destroy(opts)
            end
          end
        end
        if self.connection.respond_to?('delete_bucket')
          self.connection.delete_bucket(key)
        elsif self.connection.respond_to?('delete_container')
          self.connection.delete_container(key)
        else
          raise 'Delete container not implemented!'
        end
        true
      rescue Excon::Errors::NotFound
        false
      end

    end
  end
end
