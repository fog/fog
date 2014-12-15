module Fog
  module Storage
    class AWS
      class Real
        # Create an object in an S3 bucket
        #
        # @param bucket_name [String] Name of bucket to create object in
        # @param object_name [String] Name of object to create
        # @param data [File||String] File or String to create object from
        # @param options [Hash]
        # @option options Cache-Control [String] Caching behaviour
        # @option options Content-Disposition [String] Presentational information for the object
        # @option options Content-Encoding [String] Encoding of object data
        # @option options Content-Length [String] Size of object in bytes (defaults to object.read.length)
        # @option options Content-MD5 [String] Base64 encoded 128-bit MD5 digest of message
        # @option options Content-Type [String] Standard MIME type describing contents (defaults to MIME::Types.of.first)
        # @option options Expires [String] Cache expiry
        # @option options x-amz-acl [String] Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # @option options x-amz-storage-class [String] Default is 'STANDARD', set to 'REDUCED_REDUNDANCY' for non-critical, reproducable data
        # @option options x-amz-meta-#{name} Headers to be returned with object, note total size of request without body must be less than 8 KB. Each name, value pair must conform to US-ASCII.
        #
        # @return [Excon::Response] response:
        #   * headers [Hash]:
        #     * ETag [String] etag of new object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUT.html

        def self.conforming_to_us_ascii!(keys, hash)
          return if RUBY_VERSION =~ /^1\.8\./
          keys.each do |k|
            v = hash[k]
            if !v.encode(::Encoding::US_ASCII, :undef => :replace).eql?(v)
              raise Excon::Errors::BadRequest.new("invalid #{k} header: value must be us-ascii")
            end
          end
        end

        def put_object(bucket_name, object_name, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          self.class.conforming_to_us_ascii! headers.keys.grep(/^x-amz-meta-/), headers

          request({
            :body       => data[:body],
            :expects    => 200,
            :headers    => headers,
            :bucket_name => bucket_name,
            :object_name => object_name,
            :idempotent => true,
            :method     => 'PUT',
          })
        end
      end

      class Mock # :nodoc:all
        require 'fog/aws/requests/storage/shared_mock_methods'
        include Fog::Storage::AWS::SharedMockMethods

        def put_object(bucket_name, object_name, data, options = {})
          define_mock_acl(bucket_name, object_name, options)

          data = parse_mock_data(data)
          headers = data[:headers].merge!(options)
          Fog::Storage::AWS::Real.conforming_to_us_ascii! headers.keys.grep(/^x-amz-meta-/), headers
          bucket = verify_mock_bucket_exists(bucket_name)

          options['Content-Type'] ||= data[:headers]['Content-Type']
          options['Content-Length'] ||= data[:headers]['Content-Length']
          object = store_mock_object(bucket, object_name, data[:body], options)

          response = Excon::Response.new
          response.status = 200

          response.headers = {
            'Content-Length'   => object['Content-Length'],
            'Content-Type'     => object['Content-Type'],
            'ETag'             => object['ETag'],
            'Last-Modified'    => object['Last-Modified'],
          }

          response.headers['x-amz-version-id'] = object['VersionId'] if object['VersionId'] != 'null'
          response
        end
      end
    end
  end
end
