require 'fog/core/model'
require 'fog/internet_archive/models/storage/ia_attributes.rb'

module Fog
  module Storage
    class InternetArchive
      class File < Fog::Model
        extend Fog::Storage::IAAttributes::ClassMethods
        include Fog::Storage::IAAttributes::InstanceMethods

        # @see AWS Object docs http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectOps.html

        # @note Chunk size to use for multipart uploads.
        #     Use small chunk sizes to minimize memory. E.g. 5242880 = 5mb
        attr_accessor :multipart_chunk_size

        attr_writer :body

        identity  :key,                 :aliases => 'Key'

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

        # treat these differently
        attribute :collections
        attribute :subjects

        ia_metadata_attribute :auto_make_bucket
        ia_metadata_attribute :cascade_delete
        ia_metadata_attribute :ignore_preexisting_bucket
        ia_metadata_attribute :interactive_priority
        ia_metadata_attribute :keep_old_version
        ia_metadata_attribute :queue_derive
        ia_metadata_attribute :size_hint

        # acl for internet archive is always public-read
        def acl
          'public-read'
        end

        def acl=(new_acl)
          'public-read'
        end

        # Get file's body if exists, else ' '.
        #
        # @return [File]
        #
        def body
          attributes[:body] ||= if last_modified && (file = collection.get(identity))
            file.body
          else
            ''
          end
        end

        # Set body attribute.
        #
        # @param [File] new_body
        # @return [File] attributes[:body]
        #
        def body=(new_body)
          attributes[:body] = new_body
        end

        # Get the file instance's directory.
        #
        # @return [Fog::InternetArchive::Storage::Directory]
        #
        def directory
          @directory
        end

        # Copy object from one bucket to other bucket.
        #
        #     required attributes: directory, key
        #
        # @param target_directory_key [String]
        # @param target_file_key [String]
        # @param options [Hash] options for copy_object method
        # @return [String] Fog::InternetArchive::Files#head status of directory contents
        #
        def copy(target_directory_key, target_file_key, options = {})
          requires :directory, :key
          service.copy_object(directory.key, key, target_directory_key, target_file_key, options)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.head(target_file_key)
        end

        # Destroy file via http DELETE.
        #
        #     required attributes: directory, key
        #
        # @param options [Hash]
        # @return [Boolean] true if successful
        #
        def destroy(options = {})
          requires :directory, :key
          options['x-archive-cascade-delete'] = cascade_delete if cascade_delete
          service.delete_object(directory.key, key, options)
          true
        end

        remove_method :metadata
        def metadata
          attributes.reject {|key, value| !(key.to_s =~ /^x-(amz||archive)-meta/)}
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

        # Set Access-Control-List permissions.
        #
        #     valid new_publics: public_read, private
        #
        # @param [String] new_public
        # @return [String] new_public
        #
        def public=(new_public)
          'public-read'
        end

        # Get publicly acessible url via http GET.
        #
        #     required attributes: directory, key
        #
        # @return [String] public url
        #
        def public_url
          requires :directory, :key
          "http://#{Fog::InternetArchive::DOMAIN_NAME}/download/#{directory.key}/#{Fog::InternetArchive.escape(key)}".gsub('%2F','/')
        end

        # Save file with body as contents to directory.key with name key via http PUT
        #
        #   required attributes: body, directory, key
        #
        # @param [Hash] options
        # @option options [String] cache_control sets Cache-Control header. For example, 'No-cache'
        # @option options [String] content_disposition sets Content-Disposition HTTP header. For exampple, 'attachment; filename=testing.txt'
        # @option options [String] content_encoding sets Content-Encoding HTTP header. For example, 'x-gzip'
        # @option options [String] content_md5 sets Content-MD5. For example, '79054025255fb1a26e4bc422aef54eb4'
        # @option options [String] content_type Content-Type. For example, 'text/plain'
        # @option options [String] expires sets number of seconds before AWS Object expires.
        # @option options [String] storage_class sets x-amz-storage-class HTTP header. Defaults to 'STANDARD'. Or, 'REDUCED_REDUNDANCY'
        # @option options [String] encryption sets HTTP encryption header. Set to 'AES256' to encrypt files at rest on S3
        # @return [Boolean] true if no errors
        #
        def save(options = {})
          requires :body, :directory, :key
          if options != {}
            Fog::Logger.deprecation("options param is deprecated [light_black](#{caller.first})[/]")
          end
          options['Cache-Control'] = cache_control if cache_control
          options['Content-Disposition'] = content_disposition if content_disposition
          options['Content-Encoding'] = content_encoding if content_encoding
          options['Content-MD5'] = content_md5 if content_md5
          options['Content-Type'] = content_type if content_type
          options['Expires'] = expires if expires
          options.merge!(metadata)

          options['x-archive-auto-make-bucket'] = auto_make_bucket if auto_make_bucket
          options['x-archive-interactive-priority'] = interactive_priority if interactive_priority
          options['x-archive-keep-old-version'] = keep_old_version if keep_old_version
          options['x-archive-queue-derive'] = queue_derive if queue_derive
          options['x-archive-size-hint'] = size_hint.to_i.to_s if size_hint

          set_metadata_array_headers(:collections, options)
          set_metadata_array_headers(:subjects, options)

          if multipart_chunk_size && body.respond_to?(:read)
            data = multipart_save(options)
            merge_attributes(data.body)
          else
            data = service.put_object(directory.key, key, body, options)
            merge_attributes(data.headers.reject {|key, value| ['Content-Length', 'Content-Type'].include?(key)})
          end
          self.etag.gsub!('"','') if self.etag
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        # Get a url for file.
        #
        #     required attributes: key
        #
        # @param expires [String] number of seconds before url expires
        # @param options [Hash]
        # @return [String] url
        #
        def url(expires, options = {})
          requires :key
          collection.get_url(key, expires, options)
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

        def multipart_save(options)
          # Initiate the upload
          res = service.initiate_multipart_upload(directory.key, key, options)
          upload_id = res.body["UploadId"]

          # Store ETags of upload parts
          part_tags = []

          # Upload each part
          # TODO: optionally upload chunks in parallel using threads
          # (may cause network performance problems with many small chunks)
          # TODO: Support large chunk sizes without reading the chunk into memory
          body.rewind if body.respond_to?(:rewind)
          while (chunk = body.read(multipart_chunk_size)) do
            md5 = Base64.encode64(Digest::MD5.digest(chunk)).strip
            part_upload = service.upload_part(directory.key, key, upload_id, part_tags.size + 1, chunk, 'Content-MD5' => md5 )
            part_tags << part_upload.headers["ETag"]
          end

        rescue
          # Abort the upload & reraise
          service.abort_multipart_upload(directory.key, key, upload_id) if upload_id
          raise
        else
          # Complete the upload
          service.complete_multipart_upload(directory.key, key, upload_id, part_tags)
        end
      end
    end
  end
end
