module Fog
  module AWS
    class S3

      # Create an object in an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - Name of bucket to create object in
      # * object_name<~String> - Name of object to create
      # * object<~String> - File to create object from
      # FIXME: deal with optional params
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :etag<~String> - etag of new object
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        request({
          :body => file[:body],
          :expects => 200,
          :headers => options.merge!(file[:headers]),
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :path => object_name
        })
      end

    end
  end
end
