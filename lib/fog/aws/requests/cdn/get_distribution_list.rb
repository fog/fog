module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/get_distribution_list'

        # List information about distributions in CloudFront
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for list.  Defaults to {}.
        #   * 'Marker'<~String> - limits object keys to only those that appear
        #     lexicographically after its value.
        #   * 'MaxItems'<~Integer> - limits number of object keys returned
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'IsTruncated'<~Boolean> - Whether or not the listing is truncated
        #     * 'Marker'<~String> - Marker specified for query
        #     * 'MaxItems'<~Integer> - Maximum number of keys specified for query
        #     * 'NextMarker'<~String> - Marker to specify for next page (id of last result of current page)
        #     * 'DistributionSummary'<~Array>:
        #       * 'S3Origin'<~Hash>:
        #         * 'DNSName'<~String> - origin to associate with distribution, ie 'mybucket.s3.amazonaws.com'
        #         * 'OriginAccessIdentity'<~String> - Optional: Used when serving private content
        #       or
        #       * 'CustomOrigin'<~Hash>:
        #         * 'DNSName'<~String> - origin to associate with distribution, ie 'www.example.com'
        #         * 'HTTPPort'<~Integer> - HTTP port of origin, in [80, 443] or (1024...65535)
        #         * 'HTTPSPort'<~Integer> - HTTPS port of origin, in [80, 443] or (1024...65535)
        #       * 'OriginProtocolPolicy'<~String> - Policy on using http vs https, in ['http-only', 'match-viewer']
        #       * 'Comment'<~String> - comment associated with distribution
        #       * 'CNAME'<~Array> - array of associated cnames
        #       * 'Enabled'<~Boolean> - whether or not distribution is enabled
        #       * 'Id'<~String> - Id of distribution
        #       * 'LastModifiedTime'<~String> - Timestamp of last modification of distribution
        #       * 'Origin'<~String> - s3 origin bucket
        #       * 'Status'<~String> - Status of distribution
        #       * 'TrustedSigners'<~Array> - trusted signers
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/ListDistributions.html

        def get_distribution_list(options = {})
          request({
            :expects    => 200,
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::CDN::AWS::GetDistributionList.new,
            :path       => "/distribution",
            :query      => options
          })
        end

      end

      class Mock

        def get_distribution_list(options = {})
          response = Excon::Response.new
          response.status = 200

          distributions = self.data[:distributions].values

          response.body = {
            'Marker' => Fog::Mock.random_hex(16),
            'IsTruncated' => false,
            'MaxItems' => 100,
            'DistributionSummary' => distributions.map { |d| to_distribution_summary(d) }
          }

          response
        end

        private

        def to_distribution_summary(d)
          {
            'DomainName' => d['DomainName'],
            'Id' => d['Id'],
            'LastModifiedTime' => d['LastModifiedTime']
          }.merge(d['DistributionConfig'])
        end
      end
    end
  end
end
