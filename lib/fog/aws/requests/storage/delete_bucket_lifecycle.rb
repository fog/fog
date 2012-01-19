module Fog
  module Storage
    class AWS
      class Real

        # Delete lifecycle configuration for a bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete lifecycle configuration from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETElifecycle.html

        def delete_bucket_lifecycle(bucket_name)
          request({
                    :expects  => 204,
                    :headers  => {},
                    :host     => "#{bucket_name}.#{@host}",
                    :method   => 'DELETE',
                    :query    => {'lifecycle' => nil}
                  })
        end
      end
    end
  end
end
