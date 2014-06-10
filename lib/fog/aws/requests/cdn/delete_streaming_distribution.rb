module Fog
  module CDN
    class AWS
      class Real
        # Delete a streaming distribution from CloudFront.
        #
        # @param [String] distribution_id Id of distribution to delete.
        # @param [String] etag Etag of that distribution from earlier get or put
        #
        # @see http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/DeleteStreamingDistribution.html

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

      class Mock
        def delete_streaming_distribution(distribution_id, etag)
          distribution = self.data[:streaming_distributions][distribution_id]

          if distribution
            if distribution['ETag'] != etag
              Fog::CDN::AWS::Mock.error(:invalid_if_match_version)
            end
            unless distribution['StreamingDistributionConfig']['CallerReference']
              Fog::CDN::AWS::Mock.error(:illegal_update)
            end
            if distribution['StreamingDistributionConfig']['Enabled']
              Fog::CDN::AWS::Mock.error(:distribution_not_disabled)
            end

            self.data[:streaming_distributions].delete(distribution_id)

            response = Excon::Response.new
            response.status = 204
            response.body = "x-amz-request-id: #{Fog::AWS::Mock.request_id}"
            response
          else
            Fog::CDN::AWS::Mock.error(:no_such_streaming_distribution)
          end
        end
      end
    end
  end
end
