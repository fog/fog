module Fog
  module Storage
    class AWS
      class Real

        # Change bucket policy for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * policy<~Hash> - policy document 
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTpolicy.html 

        def put_bucket_policy(bucket_name, policy)
          request({
            :body     => MultiJson.encode(policy),
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :query    => {'policy' => nil}
          })
        end

      end
    end
  end
end

