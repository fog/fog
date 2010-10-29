require 'fog/core/model'

module Fog
  module AWS
    class Storage

      class File < Fog::Model

        identity  :key,             :aliases => 'Key'

        attr_writer :body
        attribute :content_length,  :aliases => 'Content-Length'
        attribute :content_type,    :aliases => 'Content-Type'
        attribute :etag,            :aliases => ['Etag', 'ETag']
        attribute :last_modified,   :aliases => ['Last-Modified', 'LastModified']
        attribute :owner,           :aliases => 'Owner'
        attribute :size,            :aliases => 'Size'
        attribute :storage_class,   :aliases => 'StorageClass'

        def acl=(new_acl)
          valid_acls = ['private', 'public-read', 'public-read-write', 'authenticated-read']
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

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

        remove_method :owner=
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
          if options != {}
            Formatador.display_line("[yellow][WARN] options param is deprecated, use acl= instead[/] [light_black](#{caller.first})[/]")
          end
          if @acl
            options['x-amz-acl'] ||= @acl
          end
          data = connection.put_object(directory.key, @key, @body, options)
          @etag = data.headers['ETag']
          true
        end

        def url(expires)
          requires :key
          collection.get_url(key, expires)
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

      end

    end
  end
end
