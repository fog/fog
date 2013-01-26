module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/list_multipart_uploads'

        # List multipart uploads for a bucket
        #
        # @param bucket_name [String] Name of bucket to list multipart uploads for
        # @param upload_id [String] upload id to list objects for
        # @param options [Hash] config arguments for list.  Defaults to {}.
        # @option options key-marker[String] limits parts to only those that appear lexicographically after this key.
        # @option options max-uploads [Integer] limits number of uploads returned
        # @option options upload-id-marker [String] limits uploads to only those that appear lexicographically after this upload id.
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * Bucket [string] Bucket where the multipart upload was initiated
        #     * IsTruncated [Boolean] Whether or not the listing is truncated
        #     * KeyMarker [String] first key in list, only upload ids after this lexographically will appear
        #     * MaxUploads [Integer] Maximum results to return
        #     * NextKeyMarker [String] last key in list, for further pagination
        #     * NextUploadIdMarker [String] last key in list, for further pagination
        #     * Upload [Hash]:
        #       * Initiated [Time] Time when upload was initiated
        #       * Initiator [Hash]:
        #         * DisplayName [String] Display name of upload initiator
        #         * ID [String] Id of upload initiator
        #       * Key [String] Key where multipart upload was initiated
        #       * Owner [Hash]:
        #         * DisplayName [String] Display name of upload owner
        #         * ID [String] Id of upload owner
        #       * StorageClass [String] Storage class of object
        #       * UploadId [String] upload id of upload containing part
        #     * UploadIdMarker [String] first key in list, only upload ids after this lexographically will appear
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/mpUploadListMPUpload.html
        #
        def list_multipart_uploads(bucket_name, options = {})
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::Storage::AWS::ListMultipartUploads.new,
            :query    => options.merge!({'uploads' => nil})
          })
        end

      end
    end
  end
end
