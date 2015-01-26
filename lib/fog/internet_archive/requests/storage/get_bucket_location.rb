module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/parsers/storage/get_bucket_location'

        # Get location constraint for an S3 bucket
        #
        # @param bucket_name [String] name of bucket to get location constraint for
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * LocationConstraint [String] - Location constraint of the bucket
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETlocation.html

        def get_bucket_location(bucket_name)
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::Storage::InternetArchive::GetBucketLocation.new,
            :query    => {'location' => nil}
          })
        end
      end

      class Mock # :nodoc:all
        def get_bucket_location(bucket_name)
          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            location_constraint = case bucket['LocationConstraint']
            when 'us-east-1'
              nil
            when 'eu-east-1'
              'EU'
            else
              bucket['LocationConstraint']
            end

            response.status = 200
            response.body = {'LocationConstraint' => location_constraint }
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
      end
    end
  end
end
