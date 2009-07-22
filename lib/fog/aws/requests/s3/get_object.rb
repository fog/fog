module Fog
  module AWS
    class S3

      # Get an object from S3
      #
      # ==== Parameters
      # * bucket_name<~String> - Name of bucket to read from
      # * object_name<~String> - Name of object to read
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~String> - Contents of object
      #   * headers<~Hash>:
      #     * 'Content-Length'<~String> - Size of object contents
      #     * 'Content-Type'<~String> - MIME type of object
      #     * 'ETag'<~String> - Etag of object
      #     * 'Last-Modified'<~String> - Last modified timestamp for object
      # FIXME: optional params
      def get_object(bucket_name, object_name)
        request({
          :expects => 200,
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :path => object_name
        })
      end

    end
  end
end
