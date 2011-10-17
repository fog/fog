module Fog
  module Storage
    class AWS
      class Real

        # Delete policy for a bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete policy from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETEpolicy.html

        def delete_bucket_policy(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'DELETE',
            :query    => {'policy' => nil}
          })
        end

      end

    end
  end
end
