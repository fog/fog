module Fog
  module Storage
    class AWS
      class Real

        # Get an expiring object url from S3 for putting an object
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

        def put_object_url(bucket_name, object_name, expires, headers = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          https_url({
            :headers  => headers,
            :host     => @host,
            :method   => 'PUT',
            :path     => "#{bucket_name}/#{object_name}"
          }, expires)
        end

      end

      class Mock # :nodoc:all

        def put_object_url(bucket_name, object_name, expires, headers = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          https_url({
            :headers  => headers,
            :host     => @host,
            :method   => 'PUT',
            :path     => "#{bucket_name}/#{object_name}"
          }, expires)
        end

      end
    end
  end
end
