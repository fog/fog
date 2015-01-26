require 'fog/core/model'

module Fog
  module Storage
    class HP
      class File < Fog::Model
        identity  :key,             :aliases => 'name'

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :etag,            :aliases => ['hash', 'Etag']
        attribute :last_modified,   :aliases => ['last_modified', 'Last-Modified'], :type => :time

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

        def directory
          @directory
        end

        def copy(target_directory_key, target_file_key)
          requires :directory, :key
          target_directory = service.directories.new(:key => target_directory_key)
          service.put_object(target_directory_key, target_file_key, nil, {'X-Copy-From' => "/#{directory.key}/#{key}" })
          target_directory.files.get(target_file_key)
        end

        def destroy
          requires :directory, :key
          service.delete_object(directory.key, key)
          true
        end

        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        #def public=(new_public)
        #  new_public
        #end

        def public_url
          requires :key
          self.collection.get_url(self.key)
        end

        # Get a url for file.
        #
        # required attributes: key
        #
        # @param expires [String] number of seconds (since 1970-01-01 00:00) before url expires
        # @param options [Hash]
        # @return [String] url
        def url(expires, options = {})
          requires :directory,:key
          service.create_temp_url(directory.key, key, expires, "GET", options)
        end

        def cdn_public_url
          requires :key
          self.collection.get_cdn_url(self.key)
        end

        def cdn_public_ssl_url
          requires :key
          self.collection.get_cdn_ssl_url(self.key)
        end

        def temp_signed_url(expires_secs, method)
          requires :directory, :key
          service.get_object_temp_url(directory.key, key, expires_secs, method)
        end

        def save(options = {})
          requires :body, :directory, :key
          options['Content-Type'] = content_type if content_type
          data = service.put_object(directory.key, key, body, options)
          merge_attributes(data.headers)
          self.content_length = Fog::Storage.get_body_size(body)
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
