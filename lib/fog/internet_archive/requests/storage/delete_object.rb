module Fog
  module Storage
    class InternetArchive
      class Real
        # Delete an object from S3
        #
        # @param bucket_name [String] Name of bucket containing object to delete
        # @param object_name [String] Name of object to delete
        #
        # @return [Excon::Response] response:
        #   * status [Integer] - 204
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectDELETE.html

        def delete_object(bucket_name, object_name, options = {})
          path = CGI.escape(object_name)

          headers = options
          request({
            :expects    => 204,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'DELETE',
            :path       => path
          })
        end
      end

      class Mock # :nodoc:all
        def delete_object(bucket_name, object_name, options = {})
          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            response.status = 204

            bucket[:objects].delete(object_name)
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
