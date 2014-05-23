require 'fog/core/collection'
require 'fog/rackspace/models/storage/file'

module Fog
  module Storage
    class Rackspace
      class Files < Fog::Collection
        # @!attribute [rw] directory
        # @return [String] The name of the directory
        # @note Methods in this class require this attribute to be set
        attribute :directory

        # @!attribute [rw] limit
        # @return [Integer] For an integer value n, limits the number of results to at most n values.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/List_Large_Number_of_Objects-d1e1521.html
        attribute :limit

        # @!attribute [rw] marker
        # @return [String] Given a string value x, return object names greater in value than the specified marker.
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/List_Large_Number_of_Objects-d1e1521.html
        attribute :marker

        # @!attribute [rw] path
        # @return [String] For a string value x, return the object names nested in the pseudo path.
        # Equivalent to setting delimiter to '/' and prefix to the path with a '/' on the end.
        attribute :path

        # @!attribute [rw] prefix
        # @return [String] For a string value x, causes the results to be limited to object names beginning with the substring x.
        attribute :prefix

        model Fog::Storage::Rackspace::File

        # Returns list of files
        # @return [Fog::Storage::Rackspace::Files] Retrieves a list files.
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/List_Objects-d1e1284.html
        def all(options = {})
          requires :directory
          options = {
            'limit'   => limit,
            'marker'  => marker,
            'path'    => path,
            'prefix'  => prefix
          }.merge!(options)
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          if parent
            load(parent.files.map {|file| file.attributes})
          else
            nil
          end
        end

        # Calls block for each file in the directory
        # @yieldparam [Fog::Storage::Rackspace::File]
        # @return [Fog::Storage::Rackspace::Directory] returns itself
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note This method retrieves files in pages. Page size is defined by the limit attribute
        alias_method :each_file_this_page, :each
        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each_file_this_page {|f| yield f}
            while subset.length == (subset.limit || 10000)
              subset = subset.all(:marker => subset.last.key)
              subset.each_file_this_page {|f| yield f}
            end

            self
          end
        end

        # Retrieves file
        # @param [String] key of file
        # @yield get yields to block after chunk of data has been received (Optional)
        # @yieldparam [String] data
        # @yieldparam [Integer] remaining
        # @yieldparam [Integer] content_length
        # @return [Fog::Storage::Rackspace:File]
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note If a block is provided, the body attribute will be empty. By default chunk size is 1 MB. This value can be changed by passing the parameter :chunk_size
        #   into the :connection_options hash in the service constructor.
        # @example Download an image from Cloud Files and save it to file
        #
        #   File.open('download.jpg', 'w') do | f |
        #     my_directory.files.get("europe.jpg") do |data, remaing, content_length|
        #       f.syswrite data
        #     end
        #   end
        #
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Retrieve_Object-d1e1856.html
        def get(key, &block)
          requires :directory
          data = service.get_object(directory.key, key, &block)
          metadata = Metadata.from_headers(self, data.headers)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key,
            :metadata => metadata
          })

          new(file_data)
        rescue Fog::Storage::Rackspace::NotFound
          nil
        end

        # Returns the public_url for the given object key
        # @param key of the object
        # @return [String] url for object
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @see Directory#public_url
        def get_url(key)
          requires :directory
          if self.directory.public_url
            Files::file_url directory.public_url, key
          end
        end

        # Get a temporary http url for a file.
        #
        # required attributes: key
        # @param key [String] the key of the file within the directory
        # @param expires [String] number of seconds (since 1970-01-01 00:00) before url expires
        # @param options [Hash]
        # @return [String] url
        # @note This URL does not use the Rackspace CDN
        def get_http_url(key, expires, options = {})
          requires :directory
          service.get_object_http_url(directory.key, key, expires, options)
        end

        # Get a temporary https url for a file.
        #
        # required attributes: key
        # @param key [String] the key of the file within the directory
        # @param expires [String] number of seconds (since 1970-01-01 00:00) before url expires
        # @param options [Hash]
        # @return [String] url
        # @note This URL does not use the Rackspace CDN
        def get_https_url(key, expires, options = {})
          service.get_object_https_url(directory.key, key, expires, options)
        end

        # View directory detail without loading file contents
        # @param key of the object
        # @param options Required for compatibility with other Fog providers. Not Used.
        # @return [Fog::Storage::Rackspace::File]
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def head(key, options = {})
          requires :directory
          data = service.head_object(directory.key, key)
          file_data = data.headers.merge({
            :key => key
          })
          new(file_data)
        rescue Fog::Storage::Rackspace::NotFound
          nil
        end

        # Create a new file object
        # @param [Hash] attributes of object
        # @return [Fog::Storage::Rackspace::File]
        def new(attributes = {})
          requires :directory
          super({ :directory => directory }.merge!(attributes))
        end

        # Returns an escaped object url
        # @param [String] path of the url
        # @param [String] key of the object
        # @return [String] escaped file url
        def self.file_url(path, key)
          return nil unless path
          "#{path}/#{Fog::Rackspace.escape(key, '/')}"
        end
      end
    end
  end
end
