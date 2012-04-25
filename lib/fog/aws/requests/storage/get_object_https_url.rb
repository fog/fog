module Fog
  module Storage
    class AWS

      module GetObjectHttpsUrl

        def get_object_https_url(bucket_name, object_name, expires, options = {})
          get_object_url(bucket_name, object_name, expires, options.merge(:scheme => 'https'))
        end

      end

      class Real

        # Get an expiring object https url from S3
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object
        # * object_name<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html

        include GetObjectHttpsUrl

      end

      class Mock # :nodoc:all

        include GetObjectHttpsUrl

      end
    end
  end
end
