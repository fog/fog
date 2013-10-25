module Fog
  module Storage
    class AWS
      class Real

        # Delete tagging for a bucket
        #
        # @param bucket_name [String] name of bucket to delete tagging from
        #
        # @return [Excon::Response] response:
        #   * status [Integer] - 204
        #
        # @see http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketDELETEtagging.html

        def delete_bucket_tagging(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :bucket_name => bucket_name,
            :method   => 'DELETE',
            :query    => {'tagging' => nil}
          })
        end

      end

    end
  end
end
