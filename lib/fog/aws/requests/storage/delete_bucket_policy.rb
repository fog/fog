module Fog
  module Storage
    class AWS
      class Real
        # Delete policy for a bucket
        #
        # @param bucket_name [String] name of bucket to delete policy from
        #
        # @return [Excon::Response] response:
        #   * status [Integer] - 204
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETEpolicy.html

        def delete_bucket_policy(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :bucket_name => bucket_name,
            :method   => 'DELETE',
            :query    => {'policy' => nil}
          })
        end
      end
    end
  end
end
