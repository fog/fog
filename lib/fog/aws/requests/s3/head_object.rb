module Fog
  module AWS
    class S3

      # Get headers for an object from S3
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~String> - Contents of object
      #   * headers<~Hash>:
      #     * 'Content-Length'<~String> - Size of object contents
      #     * 'Content-Type'<~String> - MIME type of object
      #     * 'ETag'<~String> - Etag of object
      #     * 'Last-Modified'<~String> - Last modified timestamp for object
      def head_object(bucket_name, object_name)
        request({
          :expects => 200,
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'HEAD',
          :path => object_name
        })
      end

    end
  end
end
