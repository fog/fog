module Fog
  module Storage
    class AWS
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
            :bucket_name => bucket_name,
            :object_name => object_name,
            :method     => 'DELETE',
            :query      => {'uploadId' => upload_id}
          })
        end

      end # Real
    end # Storage
  end # AWS
end # Fog
