module Fog
  module Storage
    class InternetArchive
      class Real

        require 'fog/internet_archive/parsers/storage/complete_multipart_upload'

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
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'POST',
            :parser     => Fog::Parsers::Storage::InternetArchive::CompleteMultipartUpload.new,
            :path       => CGI.escape(object_name),
            :query      => {'uploadId' => upload_id}
          })
        end

      end # Real
    end # Storage
  end # InternetArchive
end # Fog
