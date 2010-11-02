module Fog
  module AWS
    class CDN
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
        #       * 'Comment'<~String> - comment associated with distribution
        #       * 'CNAME'<~Array> - array of associated cnames
        #       * 'DomainName'<~String> - Domain name of distribution
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
            :parser   => Fog::Parsers::AWS::CDN::GetDistributionList.new,
            :path       => "/distribution",
            :query      => options
          })
        end

      end

      class Mock # :nodoc:all

        def get_distribution_list(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
