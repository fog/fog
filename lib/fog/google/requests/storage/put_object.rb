module Fog
  module Google
    class Storage
      class Real

        # Create an object in an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to create object in
        # * object_name<~String> - Name of object to create
        # * data<~File> - File or String to create object from
        # * options<~Hash>:
        #   * 'Cache-Control'<~String> - Caching behaviour
        #   * 'Content-Disposition'<~String> - Presentational information for the object
        #   * 'Content-Encoding'<~String> - Encoding of object data
        #   * 'Content-Length'<~String> - Size of object in bytes (defaults to object.read.length)
        #   * 'Content-MD5'<~String> - Base64 encoded 128-bit MD5 digest of message (defaults to Base64 encoded MD5 of object.read)
        #   * 'Content-Type'<~String> - Standard MIME type describing contents (defaults to MIME::Types.of.first)
        #   * 'x-amz-acl'<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        #   * "x-amz-meta-#{name}" - Headers to be returned with object, note total size of request without body must be less than 8 KB.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'ETag'<~String> - etag of new object
        def put_object(bucket_name, object_name, data, options = {})
          data = parse_data(data)
          headers = data[:headers].merge!(options)
          request({
            :body       => data[:body],
            :expects    => 200,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'PUT',
            :path       => CGI.escape(object_name)
          })
        end

      end

      class Mock

        def put_object(bucket_name, object_name, data, options = {})
          data = parse_data(data)
          unless data[:body].is_a?(String)
            data[:body] = data[:body].read
          end
          response = Excon::Response.new
          if (bucket = @data[:buckets][bucket_name])
            response.status = 200
            bucket[:objects][object_name] = {
              :body           => data[:body],
              'ETag'          => Fog::Google::Mock.etag,
              'Key'           => object_name,
              'LastModified'  => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000"),
              'Size'          => data[:headers]['Content-Length'],
              'StorageClass'  => 'STANDARD'
            }
            bucket[:objects][object_name]['Content-Type'] = data[:headers]['Content-Type']
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
