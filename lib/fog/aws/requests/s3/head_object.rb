module Fog
  module AWS
    class S3

      # Get headers for an object from S3
      # FIXME: docs
      def head_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'HEAD',
          :path => object_name
        })
      end

    end
  end
end
