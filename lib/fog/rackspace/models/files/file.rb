require 'fog/model'

module Fog
  module Rackspace
    module Files

      class File < Fog::Model

        identity  :key,             'Key'

        attr_accessor :body
        attribute :content_length,  'Content-Length'
        attribute :content_type,    'Content-Type'
        attribute :etag,            'Etag'
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
          connection.delete_object(directory.name, @key)
          true
        end

        def owner=(new_owner)
          if new_owner
            @owner = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        def save(options = {})
          requires :body, :directory, :key
          data = connection.put_object(directory.name, @key, @body, options)
          @etag = data.headers['ETag']
          true
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

      end

    end
  end
end
