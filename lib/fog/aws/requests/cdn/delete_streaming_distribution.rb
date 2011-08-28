module Fog
  module CDN
    class AWS
      class Real

        # Delete a streaming distribution from CloudFront
        #
        # ==== Parameters
        # * distribution_id<~String> - Id of distribution to delete
        # * etag<~String> - etag of that distribution from earlier get or put
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/DeleteStreamingDistribution.html

        def delete_streaming_distribution(distribution_id, etag)
          request({
            :expects    => 204,
            :headers    => { 'If-Match' => etag },
            :idempotent => true,
            :method     => 'DELETE',
            :path       => "/streaming-distribution/#{distribution_id}"
          })
        end

      end
    end
  end
end
