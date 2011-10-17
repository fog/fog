module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/get_invalidation_list'

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
        #     * 'InvalidationSummary'<~Array>:
        #       * 'Id'<~String>:
        #       * 'Status'<~String>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/ListInvalidation.html
        
        def get_invalidation_list(distribution_id, options = {})
          request({
            :expects    => 200,
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::CDN::AWS::GetInvalidationList.new,
            :path       => "/distribution/#{distribution_id}/invalidation",
            :query      => options
          })
        end

      end
    end
  end
end
