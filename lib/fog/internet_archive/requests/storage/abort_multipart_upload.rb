module Fog
  module Storage
    class InternetArchive
      class Real
        #
        # Abort a multipart upload
        #
        # @param [String] bucket_name Name of bucket to abort multipart upload on
        # @param [String] object_name Name of object to abort multipart upload on
        # @param [String] upload_id Id of upload to add part to
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadAbort.html
        #
        def abort_multipart_upload(bucket_name, object_name, upload_id)
          request({
            :expects    => 204,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'DELETE',
            :path       => CGI.escape(object_name),
            :query      => {'uploadId' => upload_id}
          })
        end
      end # Real
    end # Storage
  end # InternetArchive
end # Fog
