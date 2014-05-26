module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/parsers/storage/initiate_multipart_upload'

        # Initiate a multipart upload to an S3 bucket
        #
        # @param bucket_name [String] Name of bucket to create object in
        # @param object_name [String] Name of object to create
        # @param options [Hash]:
        # @option options [String] Cache-Control Caching behaviour
        # @option options [String] Content-Disposition Presentational information for the object
        # @option options [String] Content-Encoding Encoding of object data
        # @option options [String] Content-MD5 Base64 encoded 128-bit MD5 digest of message (defaults to Base64 encoded MD5 of object.read)
        # @option options [String] Content-Type Standard MIME type describing contents (defaults to MIME::Types.of.first)
        # @option options [String] x-amz-acl Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # @option options [String] x-amz-meta-#{name} Headers to be returned with object, note total size of request without body must be less than 8 KB.
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * Bucket [String] - Bucket where upload was initiated
        #     * Key [String] - Object key where the upload was initiated
        #     * UploadId [String] - Id for initiated multipart upload
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadInitiate.html
        #
        def initiate_multipart_upload(bucket_name, object_name, options = {})
          request({
            :expects    => 200,
            :headers    => options,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'POST',
            :parser     => Fog::Parsers::Storage::InternetArchive::InitiateMultipartUpload.new,
            :path       => CGI.escape(object_name),
            :query      => {'uploads' => nil}
          })
        end
      end # Real
    end # Storage
  end # InternetArchive
end # Fog
