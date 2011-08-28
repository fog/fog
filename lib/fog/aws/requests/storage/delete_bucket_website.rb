module Fog
  module Storage
    class AWS
      class Real

        # Delete website configuration for a bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete website configuration from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETEwebsite.html

        def delete_bucket_website(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'DELETE',
            :query    => {'website' => nil}
          })
        end

      end

    end
  end
end
