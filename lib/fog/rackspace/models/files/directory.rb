require 'fog/model'
require 'fog/rackspace/models/files/files'

module Fog
  module Rackspace
    module Files

      class Directory < Fog::Model
        extend Fog::Deprecation
        deprecate(:name, :key)
        deprecate(:name=, :key=)

        identity  :key, ['name']

        attribute :bytes
        attribute :count

        def destroy
          requires :key
          connection.delete_container(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Rackspace::Files::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def save
          requires :key
          connection.put_container(key)
          true
        end

      end

    end
  end
end
