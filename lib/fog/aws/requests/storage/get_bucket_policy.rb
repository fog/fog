module Fog
  module Storage
    class AWS
      class Real

        # Get bucket policy for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get policy for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash> - policy document
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETpolicy.html

        def get_bucket_policy(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          response = request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :query      => {'policy' => nil}
          })
          response.body = MultiJson.decode(response.body) unless response.body.nil?
        end

      end

    end
  end
end
