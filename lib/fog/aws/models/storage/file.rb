require 'fog/core/model'
require 'fog/aws/models/storage/versions'

module Fog
  module Storage
    class AWS

      class File < Fog::Model

        identity  :key,             :aliases => 'Key'

        attr_writer :body
        attribute :cache_control,       :aliases => 'Cache-Control'
        attribute :content_disposition, :aliases => 'Content-Disposition'
        attribute :content_encoding,    :aliases => 'Content-Encoding'
        attribute :content_length,      :aliases => ['Content-Length', 'Size'], :type => :integer
        attribute :content_md5,         :aliases => 'Content-MD5'
        attribute :content_type,        :aliases => 'Content-Type'
        attribute :etag,                :aliases => ['Etag', 'ETag']
        attribute :expires,             :aliases => 'Expires'
        attribute :last_modified,       :aliases => ['Last-Modified', 'LastModified']
        attribute :metadata
        attribute :owner,               :aliases => 'Owner'
        attribute :storage_class,       :aliases => ['x-amz-storage-class', 'StorageClass']
        attribute :encryption,          :aliases => 'x-amz-server-side-encryption'
        attribute :version,             :aliases => 'x-amz-version-id'

        def acl=(new_acl)
          valid_acls = ['private', 'public-read', 'public-read-write', 'authenticated-read']
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

        def body
          attributes[:body] ||= if last_modified && (file = collection.get(identity))
            file.body
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

        def copy(target_directory_key, target_file_key, options = {})
          requires :directory, :key
          connection.copy_object(directory.key, key, target_directory_key, target_file_key, options)
          target_directory = connection.directories.new(:key => target_directory_key)
          target_directory.files.head(target_file_key)
        end

        def destroy(options = {})
          requires :directory, :key
          attributes[:body] = nil if options['versionId'] == version
          connection.delete_object(directory.key, key, options)
          true
        end

        remove_method :metadata
        def metadata
          attributes.reject {|key, value| !(key.to_s =~ /^x-amz-meta-/)}
        end

        remove_method :metadata=
        def metadata=(new_metadata)
          merge_attributes(new_metadata)
        end

        remove_method :owner=
        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        def public=(new_public)
          if new_public
            @acl = 'public-read'
          else
            @acl = 'private'
          end
          new_public
        end

        def public_url
          requires :directory, :key
          if connection.get_object_acl(directory.key, key).body['AccessControlList'].detect {|grant| grant['Grantee']['URI'] == 'http://acs.amazonaws.com/groups/global/AllUsers' && grant['Permission'] == 'READ'}
            if directory.key.to_s =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
              "https://#{directory.key}.s3.amazonaws.com/#{Fog::AWS.escape(key)}"
            else
              "https://s3.amazonaws.com/#{directory.key}/#{Fog::AWS.escape(key)}"
            end
          else
            nil
          end
        end

        def save(options = {})
          requires :body, :directory, :key
          if options != {}
            Fog::Logger.deprecation("options param is deprecated, use acl= instead [light_black](#{caller.first})[/]")
          end
          options['x-amz-acl'] ||= @acl if @acl
          options['Cache-Control'] = cache_control if cache_control
          options['Content-Disposition'] = content_disposition if content_disposition
          options['Content-Encoding'] = content_encoding if content_encoding
          options['Content-MD5'] = content_md5 if content_md5
          options['Content-Type'] = content_type if content_type
          options['Expires'] = expires if expires
          options.merge!(metadata)
          options['x-amz-storage-class'] = storage_class if storage_class
          options['x-amz-server-side-encryption'] = encryption if encryption

          data = connection.put_object(directory.key, key, body, options)
          data.headers['ETag'].gsub!('"','')
          merge_attributes(data.headers)
          self.content_length = Fog::Storage.get_body_size(body)
          true
        end

        def url(expires, options = {})
          requires :key
          collection.get_https_url(key, expires, options)
        end

        def versions
          @versions ||= begin
            Fog::Storage::AWS::Versions.new(
              :file         => self,
              :connection   => connection
            )
          end
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

      end

    end
  end
end
