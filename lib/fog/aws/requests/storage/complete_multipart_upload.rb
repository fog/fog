module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/complete_multipart_upload'

        # Complete a multipart upload
        #
        # @param [String] bucket_name Name of bucket to complete multipart upload for
        # @param [String] object_name Name of object to complete multipart upload for
        # @param [String] upload_id Id of upload to add part to
        # @param [Array<String>] parts Array of etags as Strings for parts
        #
        # @return [Excon::Response]
        #   * headers [Hash]:
        #     * Bucket [String] - bucket of new object
        #     * ETag [String] - etag of new object (will be needed to complete upload)
        #     * Key [String] - key of new object
        #     * Location [String] - location of new object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadComplete.html
        #
        def complete_multipart_upload(bucket_name, object_name, upload_id, parts)
          data = "<CompleteMultipartUpload>"
          parts.each_with_index do |part, index|
            data << "<Part>"
            data << "<PartNumber>#{index + 1}</PartNumber>"
            data << "<ETag>#{part}</ETag>"
            data << "</Part>"
          end
          data << "</CompleteMultipartUpload>"
          request({
            :body       => data,
            :expects    => 200,
            :headers    => { 'Content-Length' => data.length },
            :bucket_name => bucket_name,
            :object_name => object_name,
            :method     => 'POST',
            :parser     => Fog::Parsers::Storage::AWS::CompleteMultipartUpload.new,
            :query      => {'uploadId' => upload_id}
          })
        end

      end # Real
    end # Storage
  end # AWS
end # Fog
