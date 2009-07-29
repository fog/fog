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
      #   * :cache_control<~String> - Caching behaviour
      #   * :content_disposition<~String> - Presentational information for the object
      #   * :content_encoding<~String> - Encoding of object data
      #   * :content_length<~String> - Size of object in bytes (defaults to object.read.length)
      #   * :content_md5<~String> - Base64 encoded 128-bit MD5 digest of message (defaults to Base64 encoded MD5 of object.read)
      #   * :content_type<~String> - Standard MIME type describing contents (defaults to MIME::Types.of.first)
      #   * :x_amz_acl<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
      #   * :"x-amz-meta-#{name} - Headers to be returned with object, note total size of request without body must be less than 8 KB.
      # FIXME: deal with x-amz-meta- headers
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :etag<~String> - etag of new object
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        headers = file[:headers]
        if options[:cache_control]
          headers['Cache-Control'] = options.delete(:cache_control)
        end
        if options[:content_disposition]
          headers['Content-Disposition'] = options.delete(:content_disposition)
        end
        if options[:content_encoding]
          headers['Content-Encoding'] = options.delete(:content_encoding)
        end
        if options[:content_length]
          headers['Content-Length'] = options.delete(:content_length)
        end
        if options[:content_md5]
          headers['Content-MD5'] = options.delete(:content_md5)
        end
        if options[:content_type]
          headers['Content-Type'] = options.delete(:content_type)
        end
        if options[:x_amz_acl]
          headers['x-amz-acl'] = options.delete(:x_amz_acl)
        end
        for key, value in options
          if key[0..10] == 'x-amz-meta-'
            headers[key] = value
          end
        end
        request({
          :body => file[:body],
          :expects => 200,
          :headers => headers,
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :path => object_name
        })
      end

    end
  end
end
