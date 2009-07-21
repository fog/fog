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
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :etag<~String> - etag of new object
      #     * :last_modified<~Time> - date object was last modified
      #
      # FIXME: allow for optional params, see aws docs
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name)
        request({
          :expects => 200,
          :headers => { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" },
          :host => "#{destination_bucket_name}.#{@host}",
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::CopyObject.new,
          :path => destination_object_name
        })
      end

    end
  end
end
