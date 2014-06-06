module Fog
  module Storage
    class InternetArchive
      class Real
        # Delete website configuration for a bucket
        #
        # @param bucket_name [String] name of bucket to delete website configuration from
        #
        # @return [Excon::Response] response:
        #   * status [Integer] - 204
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketDELETEwebsite.html

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
