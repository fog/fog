module Fog
  module Storage
    class InternetArchive
      class Real
        # Upload a part for a multipart upload
        #
        # @param bucket_name [String] Name of bucket to add part to
        # @param object_name [String] Name of object to add part to
        # @param upload_id [String] Id of upload to add part to
        # @param part_number [String] Index of part in upload
        # @param data [File||String] Content for part
        # @param options [Hash]
        # @option options Content-MD5 [String] Base64 encoded 128-bit MD5 digest of message
        #
        # @return [Excon::Response] response
        #   * headers [Hash]:
        #     * ETag [String] etag of new object (will be needed to complete upload)
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadUploadPart.html
        #
        def upload_part(bucket_name, object_name, upload_id, part_number, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = options
          headers['Content-Length'] = data[:headers]['Content-Length']
          request({
            :body       => data[:body],
            :expects    => 200,
            :idempotent => true,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'PUT',
            :path       => CGI.escape(object_name),
            :query      => {'uploadId' => upload_id, 'partNumber' => part_number}
          })
        end
      end # Real
    end # Storage
  end # InternetArchive
end # Fog
