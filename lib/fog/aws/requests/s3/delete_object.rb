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
