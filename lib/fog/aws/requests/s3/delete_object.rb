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
            :expects => 204,
            :headers => {},
            :host => "#{bucket_name}.#{@host}",
            :method => 'DELETE',
            :path => object_name
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
          object_status = get_object(bucket_name, object_name).status
          if object_status == 200
            response.status = 204
            bucket = @data['Buckets'].select {|bucket| bucket['Name'] == bucket_name}.first
            bucket['Contents'].delete_if {|object| object['Key'] == object_name}
          else
            response.status = object_status
          end
          response
        end

      end
    end
  end

end