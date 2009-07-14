module Fog
  module AWS
    class S3

      # Copy an object from one S3 bucket to another
      # FIXME: docs
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name)
        request({
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
