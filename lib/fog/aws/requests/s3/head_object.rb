module Fog
  module AWS
    class S3

      # Get headers for an object from S3
      #
      # ==== Parameters
      # * bucket_name<~String> - Name of bucket to read from
      # * object_name<~String> - Name of object to read
      # * options<~Hash>:
      #   * :if_match<~String> - Returns object only if its etag matches this value, otherwise returns 412 (Precondition Failed).
      #   * :if_modified_since<~Time> - Returns object only if it has been modified since this time, otherwise returns 304 (Not Modified).
      #   * :if_none_match<~String> - Returns object only if its etag differs from this value, otherwise returns 304 (Not Modified)
      #   * :if_unmodified_since<~Time> - Returns object only if it has not been modified since this time, otherwise returns 412 (Precodition Failed).
      #   * :range<~String> - Range of object to download
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~String> - Contents of object
      #   * headers<~Hash>:
      #     * 'Content-Length'<~String> - Size of object contents
      #     * 'Content-Type'<~String> - MIME type of object
      #     * 'ETag'<~String> - Etag of object
      #     * 'Last-Modified'<~String> - Last modified timestamp for object
      def head_object(bucket_name, object_name, options={})
        headers = {}
        headers['If-Match'] = options[:if_match] if options[:if_match]
        headers['If-Modified-Since'] = options[:if_modified_since].utc.strftime("%a, %d %b %Y %H:%M:%S +0000") if options[:if_modified_since]
        headers['If-None-Match'] = options[:if_none_match] if options[:if_none_match]
        headers['If-Unmodified-Since'] = options[:if_unmodified_since].utc.strftime("%a, %d %b %Y %H:%M:%S +0000") if options[:if_unmodified_since]
        headers[:range] = options[:range] if options[:range]

        request({
          :expects => 200,
          :headers => headers,
          :host => "#{bucket_name}.#{@host}",
          :method => 'HEAD',
          :path => object_name
        })
      end

    end
  end
end
