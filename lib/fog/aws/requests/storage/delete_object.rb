module Fog
  module Storage
    class AWS
      class Real

        # Delete an object from S3
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object to delete
        # * object_name<~String> - Name of object to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 204
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectDELETE.html

        def delete_object(bucket_name, object_name, options = {})
          headers = options
          request({
            :expects    => 204,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'DELETE',
            :path       => CGI.escape(object_name)
          })
        end

      end

      class Mock # :nodoc:all

        def delete_object(bucket_name, object_name, options = {})
          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            response.status = 204

            if bucket[:versioning]
              delete_marker = {
                :delete_marker    => true,
                'Key'             => object_name,
                'VersionId'       => Fog::Mock.random_base64(32),
                'Last-Modified'   => Fog::Time.now.to_date_header
              }

              bucket[:objects][object_name] ||= []
              bucket[:objects][object_name] << delete_marker
            else
              bucket[:objects].delete(object_name)
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 204}, response))
          end
          response
        end

      end
    end
  end
end
