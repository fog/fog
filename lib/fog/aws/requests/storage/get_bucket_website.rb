module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/get_bucket_website'

        # Get website configuration for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get website configuration for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * IndexDocument<~Hash>
        #       * Suffix<~String> - Suffix appended when directory is requested
        #     * ErrorDocument<~Hash>
        #       * Key<~String> - Object key to return for 4XX class errors
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETwebsite.html

        def get_bucket_website(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Storage::AWS::GetBucketWebsite.new,
            :query      => {'website' => nil}
          })
        end

      end
    end
  end
end
