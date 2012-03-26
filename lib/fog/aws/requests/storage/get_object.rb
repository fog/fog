module Fog
  module Storage
    class AWS
      class Real

        # Get an object from S3
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket to read from
        # * object_name<~String> - Name of object to read
        # * options<~Hash>:
        #   * 'If-Match'<~String> - Returns object only if its etag matches this value, otherwise returns 412 (Precondition Failed).
        #   * 'If-Modified-Since'<~Time> - Returns object only if it has been modified since this time, otherwise returns 304 (Not Modified).
        #   * 'If-None-Match'<~String> - Returns object only if its etag differs from this value, otherwise returns 304 (Not Modified)
        #   * 'If-Unmodified-Since'<~Time> - Returns object only if it has not been modified since this time, otherwise returns 412 (Precodition Failed).
        #   * 'Range'<~String> - Range of object to download
        #   * 'versionId'<~String> - specify a particular version to retrieve
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - Contents of object
        #   * headers<~Hash>:
        #     * 'Content-Length'<~String> - Size of object contents
        #     * 'Content-Type'<~String> - MIME type of object
        #     * 'ETag'<~String> - Etag of object
        #     * 'Last-Modified'<~String> - Last modified timestamp for object
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectGET.html

        def get_object(bucket_name, object_name, options = {}, &block)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end

          params = { :headers => {} }
          if version_id = options.delete('versionId')
            params[:query] = {'versionId' => version_id}
          end
          params[:headers].merge!(options)
          if options['If-Modified-Since']
            params[:headers]['If-Modified-Since'] = Fog::Time.at(options['If-Modified-Since'].to_i).to_date_header
          end
          if options['If-Unmodified-Since']
            params[:headers]['If-Unmodified-Since'] = Fog::Time.at(options['If-Unmodified-Since'].to_i).to_date_header
          end

          if block_given?
            params[:response_block] = Proc.new
          end

          request(params.merge!({
            :expects  => [ 200, 206 ],
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :path     => CGI.escape(object_name),
          }))
        end

      end

      class Mock # :nodoc:all

        def get_object(bucket_name, object_name, options = {}, &block)
          version_id = options.delete('versionId')

          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end

          unless object_name
            raise ArgumentError.new('object_name is required')
          end

          response = Excon::Response.new
          if (bucket = self.data[:buckets][bucket_name])
            object = nil
            if bucket[:objects].has_key?(object_name)
              object = version_id ? bucket[:objects][object_name].find { |object| object['VersionId'] == version_id} : bucket[:objects][object_name].first
            end

            if (object && !object[:delete_marker])
              if options['If-Match'] && options['If-Match'] != object['ETag']
                response.status = 412
              elsif options['If-Modified-Since'] && options['If-Modified-Since'] > Time.parse(object['Last-Modified'])
                response.status = 304
              elsif options['If-None-Match'] && options['If-None-Match'] == object['ETag']
                response.status = 304
              elsif options['If-Unmodified-Since'] && options['If-Unmodified-Since'] < Time.parse(object['Last-Modified'])
                response.status = 412
              else
                response.status = 200
                for key, value in object
                  case key
                  when 'Cache-Control', 'Content-Disposition', 'Content-Encoding', 'Content-Length', 'Content-MD5', 'Content-Type', 'ETag', 'Expires', 'Last-Modified', /^x-amz-meta-/
                    response.headers[key] = value
                  end
                end

                response.headers['x-amz-version-id'] = object['VersionId'] if bucket[:versioning]

                unless block_given?
                  response.body = object[:body]
                else
                  data = StringIO.new(object[:body])
                  remaining = data.length
                  while remaining > 0
                    chunk = data.read([remaining, Excon::CHUNK_SIZE].min)
                    block.call(chunk)
                    remaining -= Excon::CHUNK_SIZE
                  end
                end
              end
            elsif version_id && !object
              response.status = 400
              response.body = {
                'Error' => {
                  'Code' => 'InvalidArgument',
                  'Message' => 'Invalid version id specified',
                  'ArgumentValue' => version_id,
                  'ArgumentName' => 'versionId',
                  'RequestId' => Fog::Mock.random_hex(16),
                  'HostId' => Fog::Mock.random_base64(65)
                }
              }

              raise(Excon::Errors.status_error({:expects => 200}, response))
            else
              response.status = 404
              response.body = "...<Code>NoSuchKey<\/Code>..."
              raise(Excon::Errors.status_error({:expects => 200}, response))
            end
          else
            response.status = 404
            response.body = "...<Code>NoSuchBucket</Code>..."
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
