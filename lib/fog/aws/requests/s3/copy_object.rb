module Fog
  module AWS
    class S3

      # Copy an object from one S3 bucket to another
      #
      # ==== Parameters
      # * source_bucket_name<~String> - Name of source bucket
      # * source_object_name<~String> - Name of source object
      # * destination_bucket_name<~String> - Name of bucket to create copy in
      # * destination_object_name<~String> - Name for new copy of object
      # * options<~Hash>:
      #   * 'x-amz-metadata-directive'<~String> - Specifies whether to copy metadata from source or replace with data in request.  Must be in ['COPY', 'REPLACE']
      #   * 'x-amz-copy_source-if-match'<~String> - Copies object if its etag matches this value
      #   * 'x-amz-copy_source-if-modified_since'<~Time> - Copies object it it has been modified since this time
      #   * 'x-amz-copy_source-if-none-match'<~String> - Copies object if its etag does not match this value
      #   * 'x-amz-copy_source-if-unmodified-since'<~Time> - Copies object it it has not been modified since this time
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * 'ETag'<~String> - etag of new object
      #     * 'LastModified'<~Time> - date object was last modified
      #
      # TODO: allow specifying new metadata (support all/some of put_object?)
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name, options = {})
        headers = { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" }.merge!(options)
        request({
          :expects => 200,
          :headers => headers,
          :host => "#{destination_bucket_name}.#{@host}",
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::CopyObject.new,
          :path => destination_object_name
        })
      end

    end
  end
end
