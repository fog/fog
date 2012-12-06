module Fog
  module Storage
    class AWS
      class Real

        # Deletes the cors configuration information set for the bucket.
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete cors rules from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETEcors.html

        def delete_bucket_cors(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'DELETE',
            :query    => {'cors' => nil}
          })
        end

      end

    end
  end
end
