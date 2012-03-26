module Fog
  module Storage
    class AWS
      class Real

        # Create an object in an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to create object in
        # * object_name<~String> - Name of object to create
        # * data<~File||String> - File or String to create object from
        # * options<~Hash>:
        #   * 'Cache-Control'<~String> - Caching behaviour
        #   * 'Content-Disposition'<~String> - Presentational information for the object
        #   * 'Content-Encoding'<~String> - Encoding of object data
        #   * 'Content-Length'<~String> - Size of object in bytes (defaults to object.read.length)
        #   * 'Content-MD5'<~String> - Base64 encoded 128-bit MD5 digest of message
        #   * 'Content-Type'<~String> - Standard MIME type describing contents (defaults to MIME::Types.of.first)
        #   * 'Expires'<~String> - Cache expiry
        #   * 'x-amz-acl'<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        #   * 'x-amz-storage-class'<~String> - Default is 'STANDARD', set to 'REDUCED_REDUNDANCY' for non-critical, reproducable data
        #   * "x-amz-meta-#{name}" - Headers to be returned with object, note total size of request without body must be less than 8 KB.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'ETag'<~String> - etag of new object
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUT.html
        #
        def put_object(bucket_name, object_name, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          request({            :body       => data[:body],
                      :expects    => 200,

            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'PUT',
            :path       => CGI.escape(object_name)
          })
        end

      end

      class Mock # :nodoc:all

        def put_object(bucket_name, object_name, data, options = {})
          acl = options['x-amz-acl'] || 'private'
          if !['private', 'public-read', 'public-read-write', 'authenticated-read'].include?(acl)
            raise Excon::Errors::BadRequest.new('invalid x-amz-acl')
          else
            self.data[:acls][:object][bucket_name] ||= {}
            self.data[:acls][:object][bucket_name][object_name] = self.class.acls(acl)
          end

          data = Fog::Storage.parse_data(data)
          unless data[:body].is_a?(String)
            data[:body] = data[:body].read
          end
          response = Excon::Response.new
          if (bucket = self.data[:buckets][bucket_name])
            response.status = 200
            object = {
              :body             => data[:body],
              'Content-Type'    => options['Content-Type'] || data[:headers]['Content-Type'],
              'ETag'            => Digest::MD5.hexdigest(data[:body]),
              'Key'             => object_name,
              'Last-Modified'   => Fog::Time.now.to_date_header,
              'Content-Length'  => options['Content-Length'] || data[:headers]['Content-Length'],
              'StorageClass'    => options['x-amz-storage-class'] || 'STANDARD',
              'VersionId'       => bucket[:versioning] == 'Enabled' ? Fog::Mock.random_base64(32) : 'null'
            }

            for key, value in options
              case key
              when 'Cache-Control', 'Content-Disposition', 'Content-Encoding', 'Content-MD5', 'Expires', /^x-amz-meta-/
                object[key] = value
              end
            end

            if bucket[:versioning]
              bucket[:objects][object_name] ||= []

              # When versioning is suspended, putting an object will create a new 'null' version if the latest version
              # is a value other than 'null', otherwise it will replace the latest version.
              if bucket[:versioning] == 'Suspended' && bucket[:objects][object_name].first['VersionId'] == 'null'
                bucket[:objects][object_name].shift
              end

              bucket[:objects][object_name].unshift(object)
            else
              bucket[:objects][object_name] = [object]
            end

            response.headers = {
              'Content-Length'   => object['Content-Length'],
              'Content-Type'     => object['Content-Type'],
              'ETag'             => object['ETag'],
              'Last-Modified'    => object['Last-Modified'],
            }

            response.headers['x-amz-version-id'] = object['VersionId'] if object['VersionId'] != 'null'
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
