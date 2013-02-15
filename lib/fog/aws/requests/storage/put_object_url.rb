module Fog
  module Storage
    class AWS
      module PutObjectUrl

        def put_object_url(bucket_name, object_name, expires, headers = {}, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          scheme_host_path_query({
            :scheme   => options[:scheme],
            :headers  => headers,
            :host     => @host,
            :port     => @port,
            :method   => 'PUT',
            :path     => "#{bucket_name}/#{object_name}"
          }, expires)
        end
      end

      class Real

        # Get an expiring object url from S3 for putting an object
        #
        # @param bucket_name [String] Name of bucket containing object
        # @param object_name [String] Name of object to get expiring url for
        # @param expires [Time] An expiry time for this url
        #
        # @return [Excon::Response] response:
        #   * body [String] url for object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html

        include PutObjectUrl

      end

      class Mock # :nodoc:all

        include PutObjectUrl

      end
    end
  end
end
