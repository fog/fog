module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/get_bucket_tagging'

        # Get tags for an S3 bucket
        #
        # @param bucket_name [String] name of bucket to get tags for
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * BucketTagging [Hash]:
        #       * Key [String] - tag key
        #       * Value [String] - tag value
        # @see http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketGETtagging.html

        def get_bucket_tagging(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :bucket_name => bucket_name,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Storage::AWS::GetBucketTagging.new,
            :query      => {'tagging' => nil}
          })
        end

      end
    end
  end
end
