require 'fog/core/model'

module Fog
  module Storage
    class Rackspace

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

        def copy(target_directory_key, target_file_key, options={})
          requires :directory, :key
          connection.copy_object(directory.key, key, target_directory_key, target_file_key)
          target_directory = connection.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        def destroy
          requires :directory, :key
          connection.delete_object(directory.key, key)
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

        def public=(new_public)
          new_public
        end

        def public_url
          requires :key
          self.collection.get_url(self.key)
        end

        def save(options = {})
          requires :body, :directory, :key
          options['Content-Type'] = content_type if content_type
          data = connection.put_object(directory.key, key, body, options)
          merge_attributes(data.headers.reject {|key, value| ['Content-Length', 'Content-Type'].include?(key)})
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
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
