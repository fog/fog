require 'fog/model'
require 'fog/google/models/storage/files'

module Fog
  module Google
    class Storage

      class Directory < Fog::Model
        extend Fog::Deprecation
        deprecate(:name, :key)
        deprecate(:name=, :key=)

        identity  :key,           :aliases => ['Name', 'name']

        attribute :creation_date, :aliases => 'CreationDate'

        def destroy
          requires :key
          connection.delete_bucket(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Google::Storage::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def save
          requires :key
          options = {}
          if @location
            options['LocationConstraint'] = @location
          end
          connection.put_bucket(key, options)
          true
        end

      end

    end
  end
end
