module Fog
  module AWS
    class S3

      # Get an object from S3
      # FIXME: docs
      def get_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :path => object_name
        })
      end

    end
  end
end
