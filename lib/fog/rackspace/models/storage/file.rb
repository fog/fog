require 'fog/core/model'

module Fog
  module Storage
    class Rackspace
      class File < Fog::Model
        # @!attribute [r] key
        # @return [String] The name of the file
        identity  :key,             :aliases => 'name'

        # @!attribute [r] content_length
        # @return [Integer] The content length of the file
        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer

        # @!attribute [rw] content_type
        # @return [String] The MIME Media Type of the file
        # @see http://www.iana.org/assignments/media-types
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']

        attribute :content_disposition, :aliases => 'Content-Disposition'

        # @!attribute [rw] etag
        # The MD5 checksum of file. If included file creation request, will ensure integrity of the file.
        # @return [String] MD5 checksum of file.
        attribute :etag,            :aliases => ['hash', 'Etag']

        # @!attribute [r] last_modified
        # The last time the file was modified
        # @return [Time] The last time the file was modified
        attribute :last_modified,   :aliases => ['last_modified', 'Last-Modified'], :type => :time

        # @!attribute [rw] access_control_allow_origin
        # A space delimited list of URLs allowed to  make Cross Origin Requests. Format is http://www.example.com. An asterisk (*) allows all.
        # @return [String] string containing a list of space delimited URLs
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/CORS_Container_Header-d1e1300.html
        attribute :access_control_allow_origin, :aliases => ['Access-Control-Allow-Origin']

        # @!attribute [rw] origin
        # @return [String] The origin is the URI of the object's host.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/CORS_Container_Header-d1e1300.html
        attribute :origin,          :aliases => ['Origin']

        # @!attribute [rw] content_encoding
        # @return [String] The content encoding of the file
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Enabling_File_Compression_with_the_Content-Encoding_Header-d1e2198.html
        attribute :content_encoding, :aliases => 'Content-Encoding'

        # @!attribute [rw] delete_at
        # A Unix Epoch Timestamp, in integer form, representing the time when this object will be automatically deleted.
        # @return [Integer] the unix epoch timestamp of when this object will be automatically deleted
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Expiring_Objects-e1e3228.html
        attribute :delete_at, :aliases => ['X-Delete-At']

        # @!attribute [rw] delete_after
        # A number of seconds representing how long from now this object will be automatically deleted.
        # @return [Integer] the number of seconds until this object will be automatically deleted
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Expiring_Objects-e1e3228.html
        attribute :delete_after, :aliases => ['X-Delete-After']

        # @!attribute [r] directory
        # @return [Fog::Storage::Rackspace::Directory] directory containing file
        attr_accessor :directory

        # @!attribute [w] public
        # @note Required for compatibility with other Fog providers. Not Used.
        attr_writer :public

        # Returns the body/contents of file
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @example Retrieve and download contents of Cloud Files object to file system
        #   file_object = directory.files.get('germany.jpg')
        #   File.open('germany.jpg', 'w') {|f| f.write(file_object.body) }
        # @see Fog::Storage::Rackspace::Files#get
        def body
          attributes[:body] ||= if last_modified
            collection.get(identity).body
          else
            ''
          end
        end

        # Sets the body/contents of file
        # @param [String,File] new_body contents of file
        def body=(new_body)
          attributes[:body] = new_body
        end

        # Copy file to another directory or directory
        # @param [String] target_directory_key
        # @param [String] target_file_key
        # @param options [Hash] used to pass in file attributes
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Copy_Object-d1e2241.html
        def copy(target_directory_key, target_file_key, options={})
          requires :directory, :key
          options['Content-Type'] ||= content_type if content_type
          options['Access-Control-Allow-Origin'] ||= access_control_allow_origin if access_control_allow_origin
          options['Origin'] ||= origin if origin
          options['Content-Encoding'] ||= content_encoding if content_encoding
          service.copy_object(directory.key, key, target_directory_key, target_file_key, options)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        # Destroy the file
        # @return [Boolean] returns true if file is destroyed
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Delete_Object-d1e2264.html
        def destroy
          requires :directory, :key
          service.delete_object(directory.key, key)
          true
        end

        # Set file metadata
        # @param [Hash,Fog::Storage::Rackspace::Metadata] hash contains key value pairs
        def metadata=(hash)
          if hash.is_a? Fog::Storage::Rackspace::Metadata
            attributes[:metadata] = hash
          else
            attributes[:metadata] = Fog::Storage::Rackspace::Metadata.new(self, hash)
          end
          attributes[:metadata]
        end

        # File metadata
        # @return [Fog::Storage::Rackspace::Metadata] metadata key value pairs.
        def metadata
          attributes[:metadata] ||= Fog::Storage::Rackspace::Metadata.new(self)
        end

        # Required for compatibility with other Fog providers. Not Used.
        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        # Set last modified
        # @param [String, Fog::Time] obj
        def last_modified=(obj)
          if obj.nil? || obj == "" || obj.is_a?(Time)
            attributes[:last_modified] = obj
            return obj
          end

          # This is a work around for swift bug that has existed for 4+ years. The is that fixing the swift bug would cause more problems than its worth.
          # For more information refer to https://github.com/fog/fog/pull/1811
          d = Date._strptime(obj,"%Y-%m-%dT%H:%M:%S")
          if d
            attributes[:last_modified] = Time.utc(d[:year], d[:mon], d[:mday], d[:hour], d[:min], d[:sec], d[:leftover], d[:zone])
          else
            attributes[:last_modified] = Time.parse(obj)
          end
        end

        # Is file published to CDN
        # @return [Boolean] return true if published to CDN
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def public?
          directory.public?
        end

        # Get a url for file.
        #
        #     required attributes: key
        #
        # @param expires [String] number of seconds (since 1970-01-01 00:00) before url expires
        # @param options [Hash]
        # @return [String] url
        # @note This URL does not use the Rackspace CDN
        #
        def url(expires, options = {})
          requires :key
          if service.ssl?
            service.get_object_https_url(directory.key, key, expires, options)
          else
            service.get_object_http_url(directory.key, key, expires, options)
          end
        end

        # Returns the public url for the file.
        # If the file has not been published to the CDN, this method will return nil as it is not publically accessible. This method will return the approprate
        # url in the following order:
        #
        # 1. If the service used to access this file was created with the option :rackspace_cdn_ssl => true, this method will return the SSL-secured URL.
        # 2. If the directory's cdn_cname attribute is populated this method will return the cname.
        # 3. return the default CDN url.
        #
        # @return [String] public url for file
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def public_url
          Files::file_url directory.public_url, key
        end

        # URL used to stream video to iOS devices without needing to convert your video
        # @return [String] iOS URL
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/iOS-Streaming-d1f3725.html
        def ios_url
          Files::file_url directory.ios_url, key
        end

        # URL used to stream resources
        # @return [String] streaming url
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Streaming-CDN-Enabled_Containers-d1f3721.html
        def streaming_url
          Files::file_url directory.streaming_url, key
        end

        # Immediately purge file from the CDN network
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note You may only PURGE up to 25 objects per day. Any attempt to purge more than this will result in a 498 status code error (Rate Limited).
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Purge_CDN-Enabled_Objects-d1e3858.html
        def purge_from_cdn
          if public?
            service.cdn.purge(self)
          else
            false
          end
        end

        # Create or updates file and associated metadata
        # @param options [Hash] additional parameters to pass to Cloud Files
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_Update_Object-d1e1965.html
        def save(options = {})
          requires :body, :directory, :key
          options['Content-Type'] = content_type if content_type
          options['Access-Control-Allow-Origin'] = access_control_allow_origin if access_control_allow_origin
          options['Origin'] = origin if origin
          options['Content-Disposition'] = content_disposition if content_disposition
          options['Etag'] = etag if etag
          options['Content-Encoding'] = content_encoding if content_encoding
          options['X-Delete-At'] = delete_at if delete_at
          options['X-Delete-After'] = delete_after if delete_after
          options.merge!(metadata.to_headers)

          data = service.put_object(directory.key, key, body, options)
          update_attributes_from(data)

          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        private

        def update_attributes_from(data)
          merge_attributes(data.headers.reject {|key, value| ['Content-Length', 'Content-Type'].include?(key)})
        end
      end
    end
  end
end
