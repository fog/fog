require 'fog/model'

module Fog
  module Rackspace
    class Storage

      class File < Fog::Model

        identity  :key,             :aliases => 'Key'

        attr_accessor :body
        attribute :content_length,  :aliases => 'Content-Length'
        attribute :content_type,    :aliases => 'Content-Type'
        attribute :etag,            :aliases => 'Etag'
        attribute :last_modified,   :aliases => 'Last-Modified'

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

        def save
          requires :body, :directory, :key
          data = connection.put_object(directory.name, @key, @body)
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
