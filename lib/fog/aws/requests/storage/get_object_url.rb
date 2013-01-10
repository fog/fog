module Fog
  module Storage
    class AWS

      module GetObjectUrl

        def get_object_url(bucket_name, object_name, expires, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          host, path = if bucket_name =~ Fog::AWS::COMPLIANT_BUCKET_NAMES
            ["#{bucket_name}.#{@host}", object_name]
          else
            [@host, "#{bucket_name}/#{object_name}"]
          end
          scheme_host_path_query({
            :scheme   => options[:scheme],
            :headers  => {},
            :host     => host,
            :port     => @port,
            :method   => 'GET',
            :path     => path,
            :query    => options[:query]
          }, expires)
        end
      end

      class Real

        # Get an expiring object url from S3
        #
        # @param bucket_name [String] Name of bucket containing object
        # @param object_name [String] Name of object to get expiring url for
        # @param expires [Time] An expiry time for this url
        #
        # @return [Excon::Response] response:
        #   * body [String] - url for object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html

        include GetObjectUrl

      end

      class Mock # :nodoc:all

        include GetObjectUrl

      end
    end
  end
end
