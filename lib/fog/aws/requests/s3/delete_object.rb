module Fog
  module AWS
    class S3

      # Delete an object from S3
      # FIXME: docs
      def delete_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'DELETE',
          :path => object_name
        })
      end

    end
  end
end
