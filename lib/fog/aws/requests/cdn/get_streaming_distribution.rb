module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/streaming_distribution'

        # Get information about a streaming distribution from CloudFront
        #
        # ==== Parameters
        # * distribution_id<~String> - id of distribution
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'S3Origin'<~Hash>:
        #       * 'DNSName'<~String> - origin to associate with distribution, ie 'mybucket.s3.amazonaws.com'
        #       * 'OriginAccessIdentity'<~String> - Optional: Used when serving private content
        #     * 'Id'<~String> - Id of distribution
        #     * 'LastModifiedTime'<~String> - Timestamp of last modification of distribution
        #     * 'Status'<~String> - Status of distribution
        #     * 'StreamingDistributionConfig'<~Array>:
        #       * 'CallerReference'<~String> - Used to prevent replay, defaults to Time.now.to_i.to_s
        #       * 'CNAME'<~Array> - array of associated cnames
        #       * 'Comment'<~String> - comment associated with distribution
        #       * 'Enabled'<~Boolean> - whether or not distribution is enabled
        #       * 'InProgressInvalidationBatches'<~Integer> - number of invalidation batches in progress
        #       * 'Logging'<~Hash>:
        #         * 'Bucket'<~String> - bucket logs are stored in
        #         * 'Prefix'<~String> - prefix logs are stored with
        #       * 'Origin'<~String> - s3 origin bucket
        #       * 'TrustedSigners'<~Array> - trusted signers
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/GetStreamingDistribution.html

        def get_streaming_distribution(distribution_id)
          request({
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::CDN::AWS::StreamingDistribution.new,
            :path       => "/streaming-distribution/#{distribution_id}"
          })
        end

      end
    end
  end
end
