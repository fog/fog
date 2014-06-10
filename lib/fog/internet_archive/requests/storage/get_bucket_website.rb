module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/parsers/storage/get_bucket_website'

        # Get website configuration for an S3 bucket
        #
        #
        # @param bucket_name [String] name of bucket to get website configuration for
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * IndexDocument [Hash]:
        #       * Suffix [String] - Suffix appended when directory is requested
        #     * ErrorDocument [Hash]:
        #       * Key [String] - Object key to return for 4XX class errors
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETwebsite.html

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
            :parser     => Fog::Parsers::Storage::InternetArchive::GetBucketWebsite.new,
            :query      => {'website' => nil}
          })
        end
      end
    end
  end
end
