module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/distribution'

        # Get information about a distribution from CloudFront
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
        #     or
        #     * 'CustomOrigin'<~Hash>:
        #       * 'DNSName'<~String> - origin to associate with distribution, ie 'www.example.com'
        #       * 'HTTPPort'<~Integer> - HTTP port of origin, in [80, 443] or (1024...65535)
        #       * 'HTTPSPort'<~Integer> - HTTPS port of origin, in [80, 443] or (1024...65535)
        #       * 'OriginProtocolPolicy'<~String> - Policy on using http vs https, in ['http-only', 'match-viewer']
        #
        #     * 'Id'<~String> - Id of distribution
        #     * 'LastModifiedTime'<~String> - Timestamp of last modification of distribution
        #     * 'Status'<~String> - Status of distribution
        #     * 'DistributionConfig'<~Array>:
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
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/GetDistribution.html

        def get_distribution(distribution_id)
          request({
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::CDN::AWS::Distribution.new,
            :path       => "/distribution/#{distribution_id}"
          })
        end

      end

      class Mock

        def get_distribution(distribution_id)
          response = Excon::Response.new

          distribution = self.data[:distributions][distribution_id]
          unless distribution
            Fog::CDN::AWS::Mock.error(:no_such_distribution)
          end

          if distribution['Status'] == 'InProgress' && (Time.now - Time.parse(distribution['LastModifiedTime']) >= Fog::Mock.delay * 2)
            distribution['Status'] = 'Deployed'
          end

          etag = Fog::CDN::AWS::Mock.generic_id
          response.status = 200
          response.body = {
            'InProgressInvalidationBatches' => 0,
          }.merge(distribution.reject { |k,v| k == 'ETag' })

          response.headers['ETag'] = etag
          distribution['ETag'] = etag

          response
        end
      end

    end
  end
end
