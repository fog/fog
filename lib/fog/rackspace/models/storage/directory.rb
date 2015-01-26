require 'fog/core/model'
require 'fog/rackspace/models/storage/files'
require 'fog/rackspace/models/storage/metadata'

module Fog
  module Storage
    class Rackspace
      class Directory < Fog::Model
        # @!attribute [r] key
        # @return [String] The name of the directory
        identity  :key, :aliases => 'name'

        # @!attribute [r] bytes
        # @return [Integer] The number of bytes used by the directory
        attribute :bytes, :aliases => 'X-Container-Bytes-Used', :type => :integer

        # @!attribute [r] count
        # @return [Integer] The number of objects in the directory
        attribute :count, :aliases => 'X-Container-Object-Count', :type => :integer

        # @!attribute [rw] cdn_name
        # @return [String] The CDN CNAME to be used instead of the default CDN directory URI. The CDN CNAME will need to be setup setup in DNS and
        #    point to the default CDN directory URI.
        # @note This value does not persist and will need to be specified each time a directory is created or retrieved
        # @see Directories#get
        attribute :cdn_cname

        # @!attribute [w] public
        # Required for compatibility with other Fog providers. Not Used.
        attr_writer :public

        # @!attribute [w] public_url
        # Required for compatibility with other Fog providers. Not Used.
        attr_writer :public_url

        # Set directory metadata
        # @param [Hash,Fog::Storage::Rackspace::Metadata] hash contains key value pairs
        def metadata=(hash)
          if hash.is_a? Fog::Storage::Rackspace::Metadata
            attributes[:metadata] = hash
          else
            attributes[:metadata] = Fog::Storage::Rackspace::Metadata.new(self, hash)
          end
          attributes[:metadata]
        end

        # Retrieve directory metadata
        # @return [Fog::Storage::Rackspace::Metadata] metadata key value pairs.
        def metadata
          unless attributes[:metadata]
             response = service.head_container(key)
             attributes[:metadata] = Fog::Storage::Rackspace::Metadata.from_headers(self, response.headers)
          end
          attributes[:metadata]
        end

        # Destroy the directory and remove it from CDN
        # @return [Boolean] returns true if directory was deleted
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note Directory must be empty before it is destroyed.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Delete_Container-d1e1765.html
        def destroy
          requires :key
          service.delete_container(key)
          service.cdn.publish_container(self, false) if cdn_enabled?
          true
        rescue Excon::Errors::NotFound
          false
        end

        # Returns collection of files in directory
        # @return [Fog::Storage::Rackspace::Files] collection of files in directory
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def files
          @files ||= begin
            Fog::Storage::Rackspace::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        # Is directory published to CDN
        # @return [Boolean] return true if published to CDN
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def public?
          if @public.nil?
            @public ||= (key && public_url) ? true : false
          end
          @public
        end

        # Reload directory with latest data from Cloud Files
        # @return [Fog::Storage::Rackspace::Directory] returns itself
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def reload
          @public = nil
          @urls = nil
          @files = nil
          super
        end

        # Returns the public url for the directory.
        # If the directory has not been published to the CDN, this method will return nil as it is not publically accessible. This method will return the approprate
        # url in the following order:
        #
        # 1. If the service used to access this directory was created with the option :rackspace_cdn_ssl => true, this method will return the SSL-secured URL.
        # 2. If the cdn_cname attribute is populated this method will return the cname.
        # 3. return the default CDN url.
        #
        # @return [String] public url for directory
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def public_url
          return nil if urls.empty?
          return urls[:ssl_uri] if service.ssl?
          cdn_cname || urls[:uri]
        end

        # URL used to stream video to iOS devices. Cloud Files will auto convert to the approprate format.
        # @return [String] iOS URL
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/iOS-Streaming-d1f3725.html
        def ios_url
          urls[:ios_uri]
        end

        # URL used to stream resources
        # @return [String] streaming url
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Streaming-CDN-Enabled_Containers-d1f3721.html
        def streaming_url
          urls[:streaming_uri]
        end

        # Create or update directory and associated metadata
        # @return [Boolean] returns true if directory was saved
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note If public attribute is true, directory will be CDN enabled
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_Container-d1e1694.html
        def save
          requires :key
          create_or_update_container
          if cdn_enabled?
            @urls = service.cdn.publish_container(self, public?)
          else
            raise Fog::Storage::Rackspace::Error.new("Directory can not be set as :public without a CDN provided") if public?
          end
          true
        end

        private

        def cdn_enabled?
          service.cdn && service.cdn.enabled?
        end

        def urls
          requires :key
          return {} unless cdn_enabled?
          @urls ||= service.cdn.urls(self)
        end

        def create_or_update_container
          headers = attributes[:metadata].nil? ? {} : metadata.to_headers
          service.put_container(key, headers)
        end
      end
    end
  end
end
