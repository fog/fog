unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Create an object in an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to create object in
        # * object_name<~String> - Name of object to create
        # * object<~String> - File to create object from
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
        # * response<~Fog::AWS::Response>:
        #   * headers<~Hash>:
        #     * 'ETag'<~String> - etag of new object
        def put_object(bucket_name, object_name, object, options = {})
          file = parse_file(object)
          headers = file[:headers].merge!(options)
          request({
            :body     => file[:body],
            :expects  => 200,
            :headers  => headers,
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :path     => object_name
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def put_object(bucket_name, object_name, object, options = {})
          file = parse_file(object)
          response = Fog::Response.new
          if (bucket = @data[:buckets][bucket_name])
            response.status = 200
            bucket[:objects][object_name] = {
              :body           => file[:body],
              'ETag'          => Fog::AWS::Mock.etag,
              'Key'           => object_name,
              'LastModified'  => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000"),
              'Owner'         => { 'DisplayName' => 'owner', 'ID' => 'some_id'},
              'Size'          => file[:headers]['Content-Length'],
              'StorageClass'  => 'STANDARD'
            }
          else
            response.status = 404
          end
          response
        end

      end
    end
  end

end
