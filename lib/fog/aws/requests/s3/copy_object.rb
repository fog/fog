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
      #   * :x_amz_metadata_directive<~String> - Specifies whether to copy metadata from source or replace with data in request.  Must be in ['COPY', 'REPLACE']
      #   * :x_amz_copy_source_if_match<~String> - Copies object if its etag matches this value
      #   * :x_amz_copy_source_if_modified_since<~Time> - Copies object it it has been modified since this time
      #   * :x_amz_copy_source_if_none_match<~String> - Copies object if its etag does not match this value
      #   * :x_amz_copy_source_if_unmodified_since<~Time> - Copies object it it has not been modified since this time
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :etag<~String> - etag of new object
      #     * :last_modified<~Time> - date object was last modified
      #
      # TODO: allow specifying new metadata (support all/some of put_object?)
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name, options = {})
        headers = { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" }
        if options[:x_amz_metadata_directive]
          headers['x-amz-metadata-directive'] = options[:x_amz_metadata_directive]
        end
        if options[:x_amz_copy_source_if_match]
          headers['x-amz-copy-source-if-match'] = options[:x_amz_copy_source_if_match]
        end
        if options[:x_amz_copy_source_if_modified_since]
          headers['x-amz-copy-source-if-modified-since'] = options[:x_amz_copy_source_if_modified_since].utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
        end
        if options[:x_amz_copy_source_if_none_match]
          headers['x-amz-copy-source-if-none-match'] = options[:x_amz_copy_source_if_none_match]
        end
        if options[:x_amz_copy_source_if_unmodified_since]
          headers['x-amz-copy-source-if-unmodified-since'] = options[:x_amz_copy_source_if_unmodified_since].utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
        end
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
