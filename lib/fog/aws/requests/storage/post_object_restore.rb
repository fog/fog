module Fog
  module Storage
    class AWS
      class Real

        # Restore an object from Glacier to its original S3 path
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object
        # * object_name<~String> - Name of object to restore
        # * days<~Integer> - Number of days to restore the object for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * TODO
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPOSTrestore.html

        def post_object_restore(bucket_name, object_name, days = 100000)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end

          data = '<RestoreRequest xmlns="http://s3.amazonaws.com/doc/2006-3-01"><Days>' + days.to_s + '</Days></RestoreRequest>'

          headers = {}
          headers['Content-MD5'] = Base64.encode64(Digest::MD5.digest(data)).strip
          headers['Content-Type'] = 'application/xml'
          headers['Date'] = Fog::Time.now.to_date_header
          
          request({
            :headers  => headers,
            :host     => "#{bucket_name}.#{@host}",
            :expect   => 202,
            :body     => data,
            :method   => 'POST',
            :query    => {'restore' => nil},
            :path     => CGI.escape(object_name)
          })
        end

      end

      class Mock # :nodoc:all

        def put_object_url(bucket_name, object_name, expires)
          raise "TODO"
        end

      end
    end
  end
end
