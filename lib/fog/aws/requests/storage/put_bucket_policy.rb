module Fog
  module Storage
    class AWS
      class Real

        # Change bucket policy for an S3 bucket
        #
        # @param bucket_name [String] name of bucket to modify
        # @param policy [Hash] policy document
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTpolicy.html

        def put_bucket_policy(bucket_name, policy)
          request({
            :body     => Fog::JSON.encode(policy),
            :expects  => 204,
            :headers  => {},
            :bucket_name => bucket_name,
            :method   => 'PUT',
            :query    => {'policy' => nil}
          })
        end

      end
    end
  end
end

