require 'fog/model'

module Fog
  module AWS
    module S3

      class File < Fog::Model

        identity  :key,             'Key'

        attr_accessor :body
        attribute :content_length,  'Content-Length'
        attribute :content_type,    'Content-Type'
        attribute :etag,            ['Etag', 'ETag']
        attribute :last_modified,   ['Last-Modified', 'LastModified']
        attribute :owner,           'Owner'
        attribute :size,            'Size'
        attribute :storage_class,   'StorageClass'

        def body
          @body ||= if last_modified && (file = collection.get(identity))
            file.body
          else
            ''
          end
        end

        def directory
          @directory
        end

        def copy(target_directory_key, target_file_key)
          requires :directory, :key
          data = connection.copy_object(directory.key, @key, target_directory_key, target_file_key).body
          target_directory = connection.directories.new(:key => target_directory_key)
          target_file = target_directory.files.new(attributes.merge!(:key => target_file_key))
          copy_data = {}
          for key, value in data
            if ['ETag', 'LastModified'].include?(key)
              copy_data[key] = value
            end
          end
          target_file.merge_attributes(copy_data)
          target_file
        end

        def destroy
          requires :directory, :key
          connection.delete_object(directory.key, @key)
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
          data = connection.put_object(directory.key, @key, @body, options)
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
