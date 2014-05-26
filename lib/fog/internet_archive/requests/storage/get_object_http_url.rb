module Fog
  module Storage
    class InternetArchive
      module GetObjectHttpUrl
        def get_object_http_url(bucket_name, object_name, expires, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          host, path = if bucket_name =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            ["#{bucket_name}.#{@host}", object_name]
          else
            [@host, "#{bucket_name}/#{object_name}"]
          end
          http_url({
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
        # Get an expiring object http url from S3
        #
        # @param bucket_name [String] Name of bucket containing object
        # @param object_name [String] Name of object to get expiring url for
        # @param expires [Time] An expiry time for this url
        #
        # @return [Excon::Response] response:
        #   * body [String] - url for object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html

        include GetObjectHttpUrl
      end

      class Mock # :nodoc:all
        include GetObjectHttpUrl
      end
    end
  end
end
