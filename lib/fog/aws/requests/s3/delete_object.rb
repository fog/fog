unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Delete an object from S3
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object to delete
        # * object_name<~String> - Name of object to delete
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * status<~Integer> - 204
        def delete_object(bucket_name, object_name)
          request({
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'DELETE',
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

        def delete_object(bucket_name, object_name)
          response = Fog::Response.new
          if bucket = Fog::AWS::S3.data[:buckets][bucket_name]
            response.status = 204
            bucket[:objects].delete(object_name)
          else
            response.status = 404
            raise(Fog::Errors.status_error(204, 404, response))
          end
          response
        end

      end
    end
  end

end