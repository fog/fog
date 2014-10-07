require 'fog/core/model'

module Fog
  module Storage
    class HP
      class SharedFile < Fog::Model
        identity  :key,             :aliases => 'name'
        attribute :url

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :etag,            :aliases => ['hash', 'Etag']
        attribute :last_modified,   :aliases => ['last_modified', 'Last-Modified'], :type => :time

        def url
          "#{self.collection.shared_directory.url}/#{key}"
        end

        def body
          attributes[:body] ||= if last_modified
            collection.get(identity).body
          else
            ''
          end
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        def destroy
          requires :shared_directory, :key
          service.delete_shared_object(self.url)
          true
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          false
        end

        def shared_directory
          @shared_directory
        end

        def save(options = {})
          requires :shared_directory, :key
          options['Content-Type'] = content_type if content_type
          data = service.put_shared_object(shared_directory.url, key, body, options)
          merge_attributes(data.headers)
          self.content_length = Fog::Storage.get_body_size(body)
          true
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          false
        end

        private

        def shared_directory=(new_shared_directory)
          @shared_directory = new_shared_directory
        end
      end
    end
  end
end
